# NLE5 Codex Log

## 2026-06-10 - Repository Workflow Adoption

Installed the minimum FLEY repository workflow surface:

- copied the canonical workflow to `_work/repo-workflow.md`
- added the NLE5 local workflow supplement
- added empty plan and todo dashboards
- added local workflow verification targets

The `fley-org` repository registry currently records NLE5 as a product
repository with candidate adoption state and unknown privacy classification.

The shared dashboard checker currently derives plan paths from its own script
location. NLE5 uses `scripts/check_work_dashboard.py` as a local execution
wrapper so the organization-owned checker validates NLE5 paths. The underlying
portability defect and the similar `site-ops` workaround were routed to
`fley-org` as `todo-070`.

This repository commit also captures the existing NLE window-port source note
and its NLE5 architecture assessment:

- `_work/nle5-window-port.md`
- `_work/nle5-window-port-assessment.md`
