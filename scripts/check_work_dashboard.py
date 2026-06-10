#!/usr/bin/env python3
"""Run the organization-owned dashboard checker against this repository."""

from __future__ import annotations

import os
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SHARED_CHECKER = Path(
    os.environ.get("FLEY_ORG", ROOT.parent / "fley-org")
) / "scripts" / "check_work_dashboard.py"

source = SHARED_CHECKER.read_text(encoding="utf-8")
scope = {"__file__": str(Path(__file__).resolve()), "__name__": "__main__"}
exec(compile(source, str(SHARED_CHECKER), "exec"), scope)
