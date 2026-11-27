---
name: git-workflow
description: Use before any Git interaction, including read-only status, diffs, logs, and history inspection, or when dealing with branches, worktrees, remotes, staging, commits, fetches, pulls, pushes, tags, or pull requests. Loads better-commits for commit review, messages, staging, and commits.
---

# Git workflow

Load this skill once per task before the first command or tool that reads or changes Git state, including when Git inspection is incidental to another task. Follow repository instructions and any more specific workflow constraints.

## Check scope

- Locate the intended repository and worktree. Use an explicit working directory or `git -C` when handling multiple repositories. Check the current branch and state when relevant; don't assume the current branch is the intended target.
- For inspection, run only the read-only checks needed to answer the question. For changes or publication, verify the relevant working tree, index, local refs, and destination first. Keep detached HEAD, merge, rebase, or cherry-pick state in mind.
- Preserve unrelated work. A request to inspect or draft does not authorize writes. A request to branch, commit, push, or open a PR authorizes only the stated actions. One request may explicitly authorize several steps. Ask if scope, base, or destination is materially ambiguous.

## Choose the workflow

- **Commit review, message, staging, or commit:** Read `../better-commits/SKILL.md` relative to this skill directory, unless already loaded for this task. Apply it before planning or making changes to the index or history.
- **Branch or worktree:** Verify the name and base. Create or switch only as requested. If the branch or worktree already exists, don't replace it. Don't stash, reset, or discard local changes to make a switch succeed. Report the resulting branch and base.
- **Fetch or integrate:** Keep fetch separate from integration when possible. For a requested pull, check the upstream, divergence, and local edits; don't choose a rebase or merge on the user's behalf if policy and intent are unclear. Stop and report conflicts rather than discarding work.
- **Push:** Identify the source branch, remote, and exact destination. Review outgoing commits and the diff against the verified remote ref, or against the intended base for a new branch. Flag unrelated changes or sensitive data without quoting secrets. Push only the requested ref; don't infer permission to force-push, delete refs, publish tags, or push directly to the default branch. If rejected, report why and stop.
- **Pull request:** Verify the head and base, review the full branch diff, and draft a title and body with verified tests or known gaps. Open it only when explicitly requested. If that requires an unpublished branch to be pushed, ask unless pushing was also requested. Report the URL or the blocker.

## Before finishing

- Do not bypass hooks, rewrite history, remove worktrees, drop stashes, or discard local changes without explicit, scoped authorization. Prefer a reversible approach when it meets the request.
- After a mutation, verify the result and report what changed, what remains local, and any checks that failed or were not run.
