.PHONY: help check-work check-repo-workflow check-plans check-todo repo-tour

PYTHON ?= python3
FLEY_ORG ?= ../fley-org

help:
	@printf '%s\n' \
		'NLE5 workflow targets:' \
		'  check-work           Run all local workflow checks.' \
		'  check-repo-workflow  Compare the local workflow with the canonical copy.' \
		'  check-plans          Validate the plan dashboard.' \
		'  check-todo           Validate the todo dashboard.' \
		'  repo-tour            Report organization repository workflow state.'

check-work: check-repo-workflow check-plans check-todo

check-repo-workflow:
	@$(MAKE) -C "$(FLEY_ORG)" check-repo-workflow REPO_WORKFLOW="$(abspath _work/repo-workflow.md)"

check-plans:
	@FLEY_ORG="$(abspath $(FLEY_ORG))" $(PYTHON) scripts/check_work_dashboard.py plan _work/plans/plans.csv

check-todo:
	@FLEY_ORG="$(abspath $(FLEY_ORG))" $(PYTHON) scripts/check_work_dashboard.py todo _work/todo.csv

repo-tour:
	@$(MAKE) -C "$(FLEY_ORG)" repo-tour WORKSPACE_ROOT="$(abspath ..)"
