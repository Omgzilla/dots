#!/usr/bin/env bash
# Run with Bash. Only this child and its subprocesses receive the extra environment.
set -e

if [[ $# != 1 || -z ${1//[[:space:]]/} ]]; then
  printf 'Usage: bash launch.sh "investigation brief"\n' >&2
  exit 2
fi

investigation_task=$1
investigation_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
investigation_cwd=$PWD
investigation_envrc=/home/marcus/.config/dwellir/.envrc
investigation_skill=$HOME/.agents/skills/dwellir-investigation/SKILL.md

for investigation_file in "$investigation_envrc" "$investigation_skill" "$investigation_dir/investigator.md"; do
  if [[ ! -r $investigation_file ]]; then
    printf 'Investigator cannot read %s\n' "$investigation_file" >&2
    exit 1
  fi
done

# Treat .envrc as trusted Bash; relative paths resolve next to the file.
# Suppress source output because it may contain credentials.
cd -- "${investigation_envrc%/*}"
trap 'printf "Could not load the Dwellir investigation environment.\n" >&2' EXIT
set -a
source "$investigation_envrc" >/dev/null 2>&1
set +a
trap - EXIT
cd -- "$investigation_cwd"

exec pi --print --no-session --no-approve --no-context-files \
  --tools read,bash,grep,find,ls,codemode \
  --skill "$investigation_skill" \
  --append-system-prompt "$investigation_dir/investigator.md" \
  -- "Investigate: $investigation_task"
