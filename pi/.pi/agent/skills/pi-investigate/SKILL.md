---
name: pi-investigate
description: Start a Dwellir investigation in a separate Pi agent with the local investigation environment loaded. Use for Dwellir endpoint behavior, customer incidents, analytics, or infrastructure investigations.
compatibility: Pi with Bash and the installed dwellir-investigation skill.
---

# Delegate a Dwellir investigation

Get the target, question, and time window if needed. Then run the bundled launcher from the relevant working directory using Bash:

```bash
bash "$HOME/.pi/agent/skills/pi-investigate/launch.sh" 'Describe the target, time window, scope, and question here.'
```

Pass the user's task as a shell-quoted argument, not as executable shell text. Include relevant context the child cannot see, but don't pass secrets. The launcher sources the local environment once per child process and hands the task to a separate Pi session. Allow enough time for the child to finish. Report its evidence, conclusions, and gaps; if startup fails, report the blocker without falling back to an unsourced session.
