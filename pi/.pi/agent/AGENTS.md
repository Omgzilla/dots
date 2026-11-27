## Dwellir investigations

For Dwellir endpoint, incident, analytics, and infrastructure investigations, load the `pi-investigate` skill and delegate before running investigative commands. This also applies when the request names `dwellir-investigation` directly: the child uses that skill after its environment is loaded. If the launcher fails, report the blocker instead of silently investigating without that environment.
