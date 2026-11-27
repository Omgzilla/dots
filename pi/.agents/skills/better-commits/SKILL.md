---
name: better-commits
description: Review staged and unstaged changes, plan commit boundaries, draft commit messages, and handle scoped staging and commits. Loaded by git-workflow for commit-related tasks.
disable-model-invocation: true
---

# Better commits

Use with the general Git safeguards in `../git-workflow/SKILL.md`. Review scope before drafting, staging, or committing. By default, preview only.

## Inspect a commit

1. Find the repository root with `git rev-parse --show-toplevel`. If outside a Git repository, stop and say so.
2. Read applicable `AGENTS.md` files and any commit or contribution guidelines they reference. Sample recent subjects with `git log -8 --format=%s -- <relevant paths>` from the repository root. If local examples conflict with written guidance, follow the written guidance. If neither establishes a convention, use a short, specific subject without inventing a prefix.
3. Run `git status --short`, `git diff --cached`, and `git diff` to distinguish staged, unstaged, and untracked work. Inspect untracked files only when relevant to the requested scope. Read enough surrounding code or documentation to understand the change, not just the filenames.
4. Treat the index as the proposed commit. If nothing is staged, say so and propose a scope without staging. Call out any file with both staged and unstaged edits if that affects the plan. Do not assume unstaged edits or untracked files belong in the commit.

## Review and draft

- Keep changes that implement one intent together, including regression tests and any required docs or changelog entries. Suggest a split only when it makes review or reversion easier and each commit leaves the repository coherent. Describe the exact paths or hunks and their order; avoid path-level staging suggestions for files that need hunk-level selection.
- Flag unrelated changes, suspicious generated files, secrets (without quoting their values), and files accidentally left out. Identify checks required by the repo and distinguish passed, failed, and not run. Don't claim to know intent, issue IDs, or verification results without evidence.
- Write a subject that names the concrete change and follows repo style. Add a body only when it helps explain why the change exists, a trade-off, or a migration or breaking impact. Describe the proposed commit, not everything in the working tree.

## Preview or execute

- For a preview, show the proposed scope, the exact commit message, and any blockers or pending checks. If recommending a split, provide those details for each proposed commit. Say what will stay out when the tree contains unrelated work.
- Stage only when explicitly asked to stage or when explicitly asked to commit a clearly specified scope that needs staging. Never use broad staging commands when they would include unspecified changes. If scope is ambiguous or the staged diff should be split, show the plan and ask before changing the index or creating a commit.
- Commit only when explicitly asked. Recheck the staged diff and status before committing; if the index differs from the intended scope, stop and resolve the mismatch with the user. Run applicable checks per repo rules and report failures or checks not run. Do not bypass hooks.
- Don't amend or rewrite history unless explicitly requested. After a commit, report its hash and subject and any changes left uncommitted.
