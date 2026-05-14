#!/usr/bin/env python3
# Create a config file according to $CONFIG_PATH
# Example config:
# {
#   "instances": [
#     {
#       "name": "pionen",
#       "grafana_url": "http://192.168.209.232:3000",
#       "prometheus_url": "http://192.168.209.174:9090",
#       "metric": "lxd_procs_total",
#       "job": "lxd-hosts",
#       "dashboard_uid": "bGY-LSB7k"
#     }
#   ]
# }
import argparse
import hashlib
import json
import os
import subprocess
import sys
import time
import webbrowser
from pathlib import Path
from typing import Dict, List, Optional

import requests

CONFIG_PATH = Path.home() / ".config/grafana/config.json"
CACHE_DIR = Path.home() / ".cache/grafana_rofi"
CACHE_DIR.mkdir(parents=True, exist_ok=True)
CACHE_EXPIRY_SECONDS = 604800 # 7d, 86400 = 1 day


def parse_args():
    parser = argparse.ArgumentParser(description="Grafana dashboard launcher with Prometheus-powered variable selection.")
    parser.add_argument("-s", "--site", help="Comma-separated site names or 'all' for every site (default: all)", default="all")
    parser.add_argument("-p", "--project", help="Project label value (default: default, ignored in rofi mode)", default="default")
    parser.add_argument("-i", "--instance", help="Instance name (e.g., container name)", required=False)
    parser.add_argument("--label", help="Label to filter on (default: name)", default="name")
    parser.add_argument("--no-cache", help="Force Prometheus refresh", action="store_true")
    parser.add_argument("--rofi", help="Use rofi for label + value selection", action="store_true")
    parser.add_argument("--fuzzy", help="Use fzf (fuzzy finder) for label selection", action="store_true")
    return parser.parse_args()


def load_config() -> List[Dict]:
    if not CONFIG_PATH.exists():
        print(f"❌ Config not found at {CONFIG_PATH}")
        sys.exit(1)
    with CONFIG_PATH.open() as f:
        return json.load(f)["instances"]


def get_instances(config, selected_sites) -> List[Dict]:
    if selected_sites == ["all"]:
        return config
    return [site for site in config if site["name"] in selected_sites]


def hash_series(series_data) -> str:
    raw = json.dumps(series_data, sort_keys=True).encode()
    return hashlib.sha256(raw).hexdigest()


def get_cache_file(site: str, metric: str, label: str) -> Path:
    return CACHE_DIR / f"{site}_{metric}_{label}.json"


def is_cache_stale(cache_file: Path) -> bool:
    return time.time() - cache_file.stat().st_mtime > CACHE_EXPIRY_SECONDS


def query_prometheus(prom_url: str, metric: str, job: str) -> List[Dict]:
    query = f'{metric}{{job="{job}"}}'
    url = f"{prom_url}/api/v1/series?match[]={requests.utils.quote(query)}"
    resp = requests.get(url)
    resp.raise_for_status()
    return resp.json()["data"]


def get_series(site_conf, label: str, use_cache: bool) -> List[Dict]:
    site = site_conf["name"]
    metric = site_conf["metric"]
    job = site_conf["job"]
    prom_url = site_conf["prometheus_url"]
    cache_file = get_cache_file(site, metric, label)

    def write_cache(data):
        with cache_file.open("w") as f:
            json.dump({
                "checksum": hash_series(data),
                "fetched_at": int(time.time()),
                "raw": data,
                "values": sorted({d[label] for d in data if label in d})
            }, f)

    try:
        if not use_cache or not cache_file.exists() or is_cache_stale(cache_file):
            data = query_prometheus(prom_url, metric, job)
            write_cache(data)
            return data
        else:
            with cache_file.open() as f:
                return json.load(f)["raw"]
    except Exception as e:
        print(f"❌ Prometheus error for {site}: {e}")
        return []


def get_label_entry(series: List[Dict], label: str, value: str) -> Optional[Dict]:
    for d in series:
        if d.get(label) == value:
            return d
    return None


def pick_with_prompt(prompt: str, options: List[str], use_fzf=False) -> Optional[str]:
    try:
        if use_fzf:
            proc = subprocess.run(
                ["fzf", "--prompt", f"{prompt}: "],
                input="\n".join(options).encode(),
                stdout=subprocess.PIPE,
                check=True
            )
        else:
            proc = subprocess.run(
                ["rofi", "-dmenu", "-p", prompt],
                input="\n".join(options).encode(),
                stdout=subprocess.PIPE,
                check=True
            )
        return proc.stdout.decode().strip()
    except subprocess.CalledProcessError:
        return None


def open_grafana(site_conf: Dict, label_values: Dict[str, str]):
    base_url = site_conf["grafana_url"]
    uid = site_conf["dashboard_uid"]
    job = site_conf["job"]

    query = f"/d/{uid}/lxd?orgId=1&from=now-6h&to=now&timezone=browser"
    query += f"&var-job={job}"
    query += f"&var-host=$__all"

    for key, val in label_values.items():
        query += f"&var-{key}={val}"

    final_url = base_url.rstrip("/") + query
    print(f"🌍 Opening: {final_url}")
    webbrowser.open(final_url)


def main():
    args = parse_args()
    config = load_config()

    if not args.site:
        print("🧠 No --site given. Use --site pionen,solna or --site all")
        sys.exit(1)

    selected_sites = args.site.split(",")
    instances = get_instances(config, selected_sites)
    if not instances:
        print("❌ No matching sites found.")
        sys.exit(1)

    label = args.label
    interactive = args.rofi or args.fuzzy

    if interactive:
        all_choices = {}
        value_to_labels = {}

        for inst in instances:
            raw_series = get_series(inst, label, not args.no_cache)
            for entry in raw_series:
                if label in entry and "project" in entry:
                    key = f"{entry[label]} [{inst['name']}]"
                    all_choices[key] = inst
                    value_to_labels[key] = entry

        choice = pick_with_prompt(f"Select {label}", sorted(all_choices), use_fzf=args.fuzzy)
        if not choice:
            sys.exit(0)

        inst = all_choices[choice]
        entry = value_to_labels.get(choice)

        # Always re-check against live data if not found
        if not entry:
            raw_series = get_series(inst, label, use_cache=False)
            val = choice.split(" [")[0]
            entry = get_label_entry(raw_series, label, val)
            if not entry:
                print("❌ Could not find that value in Prometheus.")
                sys.exit(1)

        open_grafana(inst, {
            label: entry[label],
            "project": entry.get("project", "default")
        })

    else:
        if not args.project or not args.instance:
            print("❌ Must provide --project and --instance in non-interactive mode.")
            sys.exit(1)

        for inst in instances:
            open_grafana(inst, {
                "project": args.project,
                "name": args.instance
            })


if __name__ == "__main__":
    main()

