from __future__ import annotations

import ctypes
import json
import os
from pathlib import Path
import subprocess
import sys
import time


PROJECT_ROOT = Path(__file__).resolve().parents[1]
REQUEST_PATH = Path(os.environ["APPDATA"]) / "Godot" / "app_userdata" / "Nox Protocol" / "port_restart_request.json"
PROCESS_QUERY_LIMITED_INFORMATION = 0x1000


def process_exists(process_id: int) -> bool:
	handle = ctypes.windll.kernel32.OpenProcess(
		PROCESS_QUERY_LIMITED_INFORMATION,
		False,
		process_id,
	)
	if not handle:
		return False
	ctypes.windll.kernel32.CloseHandle(handle)
	return True


def write_state(state: str) -> None:
	REQUEST_PATH.parent.mkdir(parents=True, exist_ok=True)
	REQUEST_PATH.write_text(json.dumps({"state": state}), encoding="utf-8")


def main() -> int:
	if len(sys.argv) != 2:
		return 2
	parent_process_id = int(sys.argv[1])
	deadline = time.monotonic() + 20.0
	while process_exists(parent_process_id) and time.monotonic() < deadline:
		time.sleep(0.1)
	try:
		subprocess.Popen(
			[sys.executable, str(PROJECT_ROOT / "run.py")],
			cwd=PROJECT_ROOT,
			creationflags=subprocess.CREATE_NEW_PROCESS_GROUP,
		)
	except OSError:
		write_state("failed")
		return 1
	write_state("restarted")
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
