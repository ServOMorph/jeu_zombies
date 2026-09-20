from __future__ import annotations

import argparse
import json
import os
from pathlib import Path


REQUEST_PATH = Path(os.environ["APPDATA"]) / "Godot" / "app_userdata" / "Nox Protocol" / "port_restart_request.json"


def main() -> int:
	parser = argparse.ArgumentParser()
	parser.add_argument("action", choices=("request", "status", "acknowledge"))
	args = parser.parse_args()
	if args.action == "status":
		if not REQUEST_PATH.exists():
			print("absent")
			return 0
		print(json.loads(REQUEST_PATH.read_text(encoding="utf-8")).get("state", "invalid"))
		return 0
	REQUEST_PATH.parent.mkdir(parents=True, exist_ok=True)
	state = "restarted" if args.action == "acknowledge" else "pending"
	REQUEST_PATH.write_text(json.dumps({"state": state}), encoding="utf-8")
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
