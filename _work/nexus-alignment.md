# NLE5 Alignment With Nexus

Date: 2026-05-21

This note aligns NLE5 with the Nexus project without coupling the two too
early.

## Relationship

Nexus and NLE5 are parallel projects:

- Nexus: a tiny standalone world running on NetHack 5.0.0.
- NLE5: an NLE-style Python control/observation bridge for NetHack 5.0.0 or a
  Nexus-derived engine.

NLE5 should not drive Nexus design before Nexus can boot a custom level.
Nexus should not import Python environment concerns into its engine tree.

## Useful Shared Assumptions

Both projects care about these NetHack 5 surfaces:

- `src/allmain.c` new-game startup
- `src/dungeon.c` topology initialization through `dat/dungeon.lua`
- `src/mklev.c` level generation and special-level dispatch
- `src/sp_lev.c` Lua special-level loading
- glyph/map observations
- message text
- status/blstats-style data
- deterministic enough reset/step behavior for short rollouts

But the order differs:

```text
Nexus first: boot a tiny world for a human player.
NLE5 first: expose a controllable NetHack 5 process to Python.
Integration later: run NLE5 against Nexus once both are independently viable.
```

## Out Of Scope For Early NLE5

Do not start by requiring:

- old NLE 3.6.x benchmark compatibility
- old agents to ascend
- old task suite parity
- RL training infrastructure
- large-scale experiment management
- Nexus-specific level semantics

The early adapter can be useful even if it only runs a random policy for a
short rollout.

## Expected Nexus Dependency Shape

When NLE5 eventually points at Nexus, prefer one of these shapes:

1. NLE5 builds against a checked-out Nexus tree path supplied by config.
2. NLE5 vendors a known Nexus commit or release snapshot.
3. NLE5 keeps a patch layer that can apply to upstream NetHack 5 or Nexus.

Avoid requiring Nexus to include NLE5 as a submodule or Python package.

## First NLE5 Investigation

When source is added to this repository, inspect upstream NLE and identify:

1. where NetHack is vendored or patched
2. where the C/C++/Cython bridge lives
3. where observations are assembled
4. how actions are injected
5. how reset and process lifecycle work
6. which assumptions are NetHack 3.6.x-specific
7. what must change for NetHack 5.0.0

The first successful test should be `reset`, one `step`, and observation
sanity, not training.
