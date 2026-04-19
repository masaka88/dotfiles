---
name: claude-md
description: Create new CLAUDE.md files or review existing ones against Anthropic's official Claude Code best practices. Use this skill whenever the user asks to create, review, audit, critique, restructure, shrink, or improve a CLAUDE.md (including implicit variants like "should this rule go in CLAUDE.md?", "is our CLAUDE.md any good?", or "clean up the /init output"). Applies equally to `./CLAUDE.md` and `./.claude/CLAUDE.md`. Always proposes changes first — never writes without approval. Create mode asks Japanese/English first; review mode edits the existing file in place.
---

# claude-md

Create or audit CLAUDE.md files against Anthropic's official best practices for Claude Code project memory.

## The core principle: the delete test

Every line in CLAUDE.md must pass this test: **"If I deleted this line, would Claude get a task wrong?"** If the answer is no, the line is noise and must be removed or abstracted.

This principle exists because Claude already knows a great deal without being told:

- Standard framework commands (`flutter test`, `npm install`, `cargo build`, …)
- How to read `pubspec.yaml` / `package.json` / `Cargo.toml` / etc. to learn dependencies and language versions
- How to list directories to learn project structure and supported platforms
- How to read `README.md` to learn the project's purpose

CLAUDE.md exists to carry what Claude **cannot** derive from these sources. Anything else is a liability: it wastes context, goes stale, and creates drift between the file and reality.

## Two modes

Determine which mode applies. Ask the user if it is ambiguous.

### Review mode — audit an existing CLAUDE.md

Triggered by: "CLAUDE.md をレビューして", "check my CLAUDE.md", "is this CLAUDE.md any good?", "clean up the /init output", etc.

Steps:

1. **Read the target file.** Check both `./CLAUDE.md` and `./.claude/CLAUDE.md`. If both exist, ask which one (or both). Also note any `CLAUDE.local.md` or subdirectory `CLAUDE.md` files for context, but do not review them unless the user asks.

2. **Read surrounding context** so you can judge what is derivable:
   - `README.md`
   - `pubspec.yaml` / `package.json` / equivalent manifest
   - Top-level directory listing (what platforms, what tooling)
   - Any `.claude/settings.json`, `.github/workflows/`, `Makefile`, `devcontainer.json`

3. **Produce a diagnosis table.** Use this exact column structure:

   | Section / Lines | Judgement | Reason |
   |---|---|---|
   | Project Overview (L5-7) | Delete | Derivable from `README.md`; already stale ("Hello World" but app now shipped) |
   | Dependencies list (L17) | Delete | Manifest (`package.json` / `pyproject.toml` / etc.) is authoritative; drifts on every dep change |
   | devcontainer execution (L21-31) | Keep | Non-derivable constraint; Claude would default to local execution |
   | Test gotchas (L86-90) | Keep | Non-obvious, WHY-backed — prevents real bug class |
   | "standard project structure" (L104) | Delete | Vague / non-verifiable |

   Judgements are `Keep` / `Delete` / `Abstract`. Cite the specific principle violated (derivable / unstable / vague / duplicate / standard framework knowledge).

4. **Summarize** the expected line-count change and list the sections that will remain.

5. **Stop and wait for approval.** The user may override specific judgements — this is expected. Do not rewrite the file at this stage.

6. **After approval**, write the revised file. Preserve git history by editing in place (do not rename).

### Create mode — build a new CLAUDE.md from scratch

Triggered by: "CLAUDE.md を作って", "initialize Claude Code for this repo", "set up project memory", etc.

Steps:

1. **Ask which language.** Never assume — always ask, though you may adapt the phrasing to the conversation. The question should cover: the choice (JP/EN), that both work identically in Claude Code, and the main trade-off (English is slightly denser in tokens and suits OSS/international teams; Japanese is more readable for JP-speaking teams). A reasonable Japanese phrasing:

   > "CLAUDE.md は日本語と英語のどちらで記述しますか？両方とも Claude Code で同等に動作します。英語はややトークン効率が良く、OSS/チーム配布に向きます。日本語は日本語話者チームで読みやすいです。"

   Use an English equivalent if the user is conversing in English. The CLAUDE.md language is **independent** of the response language — e.g., writing CLAUDE.md in English and instructing "respond in Japanese" is a valid combination.

2. **Explore the project** to find what is genuinely non-obvious. Read, do not just glance:
   - `README.md`
   - Package manifest(s)
   - Top-level directory structure
   - `.claude/`, `.github/workflows/`, `Makefile`, `devcontainer.json`, CI configs
   - Anything unusual: monorepo layout, custom build scripts, non-default toolchain

3. **Interview the user** for context you cannot read from the filesystem:
   - Response language preference (separate from CLAUDE.md language)
   - Non-default execution environment (devcontainer, nix shell, pinned Node version)
   - Known gotchas / past bugs worth documenting (ask: "any footguns future-you would want warned about?")
   - Team conventions: commit message style, PR workflow, branch naming
   - Any setup step that is **not** in the README

4. **Propose a draft in chat.** Do not write to disk. Include only content that passes the delete test. Follow the section guide below.

5. **Ask about location** once the draft is approved. See the "Location" section below for the options to present.

6. **After approval**, write the file.

## What belongs in CLAUDE.md

Include content that is **all** of the following:

1. **Non-derivable** — cannot be read from manifests, READMEs, directory listings, or framework knowledge.
2. **Stable** — survives ordinary code changes without going stale.
3. **Specific and verifiable** — "2-space indent" beats "clean formatting"; "`devcontainer exec --workspace-folder <root> flutter test`" beats "run tests in the container".
4. **WHY-backed when non-obvious** — if a rule would surprise a reader, explain the reason so the reader can judge edge cases.

Typical good entries:

- Response language directive
- Non-standard execution environment (devcontainer / nix / pinned runtime)
- Known gotchas with their root cause (e.g., "use `pump` not `pumpAndSettle` — Hive hangs")
- Team conventions invisible in the code (commit style, PR rules, review norms)
- Commands that differ from the framework default

## What to exclude

| Category | Why exclude |
|---|---|
| Dependency lists / versions | Manifest is authoritative; drifts on every update |
| Directory trees | `ls` shows the truth; drifts on every file add/rename |
| Standard framework commands | Claude already knows `flutter test`, `npm test`, etc. |
| Platform lists | `/ios`, `/android`, `/web` directories are the truth |
| Project purpose / tagline | Duplicates `README.md` |
| Stale snapshots ("currently shows Hello World") | Guaranteed to lie within weeks |
| Vague advice ("write clean code") | Not actionable, not verifiable |
| `/init` boilerplate left unedited | Most of it fails the delete test |

## When NOT to create a CLAUDE.md

Some projects do not benefit from a CLAUDE.md at all. Skip creation (or recommend deletion) when:

- The repo is a throwaway script, sandbox, or single-file experiment.
- Everything non-derivable fits in the `README.md` without distorting it.
- No team conventions, execution quirks, or gotchas exist yet — writing an empty shell now just invites `/init` boilerplate later.

A missing CLAUDE.md is better than one full of noise. Offer to revisit once real non-derivable content emerges.

## Target length

- **Under 200 lines** is the official target.
- If legitimate content exceeds this, split via `@path/to/section.md` imports (Claude Code resolves them, up to 5 levels of recursion) or move stable reference material into subdirectory `CLAUDE.md` files that load on demand.
- Do **not** pad to meet a minimum — short CLAUDE.md files are a good sign.

## Location

Both paths are auto-loaded by Claude Code and treated equivalently:

- `./CLAUDE.md` — most visible
- `./.claude/CLAUDE.md` — root stays clean

When **creating**: propose `./CLAUDE.md` by default but mention the alternative.
When **reviewing**: do not move a file between locations unless the user asks.

`CLAUDE.local.md` is for personal overrides and should be `.gitignore`d. Do not put team rules there.

## Language choice: Japanese vs English

Always ask. Never assume. Trade-offs to share with the user:

- **English**: slight model-performance edge (training-data skew), denser tokens (roughly 1.3–2× fewer tokens than equivalent Japanese, depending on content), natural for OSS / international teams.
- **Japanese**: most readable for Japanese-speaking teams, no practical downside for solo or JP-only projects.

The CLAUDE.md language is independent of the response language. Mixing is fine.

## Never auto-write

This is firm. Always propose first, apply second. The user must explicitly approve before any file is written or edited. Applies to both modes:

- **Review mode**: show the diagnosis table, wait for "apply" / "書いて" / equivalent.
- **Create mode**: show the full draft in chat, wait for approval, then write to the chosen location.

Even if the user's initial phrasing sounds like an instruction to write immediately ("create CLAUDE.md for this project"), treat the first output as a draft proposal — it is cheap for them to redirect at this stage and expensive to undo later.
