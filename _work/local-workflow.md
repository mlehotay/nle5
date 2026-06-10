# NLE5 Local Workflow

This file supplements `_work/repo-workflow.md` with NLE5-specific routing and
verification rules.

## Work Routing

- Keep NLE5 control bridge, Python environment, observation, rendering, and
  adapter work in this repository.
- Route NetHack 5 or Nexus engine behavior to the owning engine repository.
- Route organization policy and cross-repository coordination to `fley-org`.
- Route controlled process work to `fley-qms`.
- Do not treat benchmark compatibility, agent training, or ascension support as
  first-milestone requirements.

## Verification

Run the narrowest available build or test for implementation changes.

Run this after changing repository workflow surfaces:

```sh
make check-work
```

Use `make repo-tour` when organization-level adoption or workflow drift needs
to be inspected.
