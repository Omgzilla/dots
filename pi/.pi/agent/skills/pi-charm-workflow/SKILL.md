---
name: pi-charm-workflow
description: Coordinate a builder, an independent code reviewer, and a tester for Juju charms in Pi. Use via /skill:pi-charm-workflow to build or change a charm and collect review and test evidence.
compatibility: Pi coding agent. Independent delegation requires a configured Pi subagent runner, such as a host exposing pi-durable subagents.
disable-model-invocation: true
---

# Pi charm workflow

Coordinate work in Pi. Repository instructions and applicable engineering skills govern charm development; this skill only assigns roles and passes evidence between them. A private workflow profile can select additional skills without storing team-specific instructions in these dotfiles.

## Start

1. Resolve the repo, scope, deliverable, and authorization. Read `charm-workflow/profile.md` under the active Pi agent directory (default `~/.pi/agent`) if it exists. Apply only the profile entries matching this repo; otherwise use repository instructions and applicable installed skills. Don't start implementation for a research-only, audit-only, or plan-only request.
2. Check which delegation tools this Pi session actually exposes. A globally installed `pi-durable` SDK does not provide a tool by itself. Use separate child conversations when a suitable runner is available. Otherwise offer the [role prompts](#roles) as handoffs for separate Pi sessions; never present your own review or test run as independent.
3. Give each worker its role prompt, the repo path, and the applicable profile instructions and installed skill paths. Require the worker to load the skills itself. If a required skill or reference is unavailable to a worker, surface the gap rather than guessing the rule.

## Roles

- [Builder](agents/builder.md): plans and implements within the requested scope.
- [Reviewer](agents/reviewer.md): checks a fixed patch in a read-only workspace, without shell, deployment, or mutation tools.
- [Tester](agents/tester.md): executes named, approved checks in an isolated workspace without production credentials or access. Live tests need separate authorization for a controller-qualified nonproduction target.

Always enforce permission boundaries through the runner or isolation mechanism, not only through child prompts. If a runner cannot provide those boundaries, use a manual handoff.

## Handoff and results

1. Let the builder finish a reviewable candidate. Freeze the exact patch, including new files, with a baseline revision (or empty tree for a new repo) and a recorded snapshot identifier. Do not commit or push just to create a snapshot. Give reviewer and tester the same snapshot, scope, compliance matrix, acceptance checks, and known limitations; do not include credentials.
2. Run review and testing in parallel when they don't depend on each other's results. Use structured results if the runner supports them; otherwise ask for Markdown using the role prompts.
3. Reconcile the results against the snapshot. Ask the builder to address confirmed findings within scope and rerun the affected checks on the revised snapshot. Earlier evidence only applies to unchanged surfaces; distinguish that from a fresh run.
4. Report the final snapshot, findings, executed checks and outcomes, and any skipped or unverified work. Keep existing CI and release gates. This workflow does not authorize a deployment, release, issue update, or merge.
