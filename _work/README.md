# NLE5 Work Area

Local planning notes for the NLE5 adapter project.

This directory is coordination space only. It is not source code, not vendored
NetHack, and not a benchmark result store.

## Project Boundary

NLE5 is the Python/control bridge project. It should eventually expose a
NetHack 5.0.0 or Nexus-derived engine through a small environment API.

It is separate from Nexus:

- Nexus owns NetHack 5 world, topology, data, Lua levels, build/install, and
  human-playable runtime behavior.
- NLE5 owns reset/step control, observations, rendering, and agent-facing
  Python integration.

Dependency direction:

```text
NLE5 may point at Nexus later.
Nexus should not depend on NLE5.
```

## First Milestone

The first NLE5 milestone is not learning and not ascension.

Success condition:

```text
env.reset() works
env.step(action) works
glyph/message/status observations are returned
a random or scripted rollout can run briefly
```

## Files

- `nexus-alignment.md` records how this project should stay aligned with the
  Nexus engine work.
- Add future plans or task files here only when the project has source code or
  a vendored upstream NLE tree to coordinate.
