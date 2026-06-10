# AGENTS.md

Instructions for Codex and other filesystem-native agents working in this repository.

## Project Identity

This repository is for the NLE 5 adapter project.

Goal:

> Port or rework the NetHack Learning Environment control/observation bridge so it can run against NetHack 5.0.0 or a closely related NetHack 5 fork.

This is not an IER repository and should not inherit IER governance, vocabulary, release checks, or theory constraints.

## Scope

Focus on a narrow technical bridge:

- build and run the Python environment
- identify how upstream NLE embeds, patches, or drives NetHack
- port only the minimum interface needed for `reset`, `step`, observations, messages, status, and rendering
- keep benchmark/ascension compatibility explicitly out of scope at first

Do not begin by training agents.
Do not begin by preserving old NLE benchmark scores.
Do not treat old ascension agents as compatibility requirements.

## First Milestone

Success condition:

```text
Python env.reset() works
Python env.step(action) works
glyph/message/status observations are returned in a sane format
```

A random or scripted policy is enough for the first milestone.

## Operating Rules

- Prefer understanding upstream NLE structure before changing files.
- Keep NetHack 5 source changes separate from Python wrapper changes where possible.
- Preserve a clear dependency direction: this repository may point at a NetHack 5 or Nexus source tree, but Nexus should not depend on this repository.
- Treat Nexus as an eventual target engine, not as a subproject to modify from NLE5.
- Do not let NLE5 benchmark or agent concerns drive Nexus before Nexus boots a custom human-playable level.
- Use `_work/` for alignment notes, plans, and task coordination once source is added.
- Avoid broad refactors until the bridge compiles and a minimal rollout works.
- Add small verification commands as they become available.
- Use the narrowest relevant test or build target.

## Repository Workflow

- Follow `_work/repo-workflow.md` for shared FLEY repository workflow.
- Follow `_work/local-workflow.md` for NLE5-specific additions.
- Keep executable work in `_work/plans/plans.csv` and `_work/todo.csv`.
- Keep expanded task context in plan files or `_work/todo.md`.
- Run `make check-work` after changing workflow surfaces.
- Route organization policy and cross-repository coordination to `fley-org`.
- Route controlled SOP, WI, CAPA, and Change Control work to `fley-qms`.

## Suggested First Codex Prompt

```text
I want to create an NLE-style Python environment for NetHack 5.0.0.

Please inspect this repository and identify:

1. the upstream NLE control/observation bridge points
2. where NetHack source is vendored, patched, or built
3. the minimum surface needed for env.reset() and env.step()
4. likely NetHack 5 API or source-layout incompatibilities
5. a smallest possible build/run milestone

Do not train agents yet.
Do not preserve old benchmark compatibility yet.
Prioritize a working NetHack 5 control bridge.
```
