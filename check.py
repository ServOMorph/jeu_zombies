from __future__ import annotations

from pathlib import Path
import subprocess
import sys


PROJECT_ROOT = Path(__file__).resolve().parent
REPORT_DIRECTORY = PROJECT_ROOT / "reports" / "local"
EXPORT_PACKAGE = REPORT_DIRECTORY / "nox_protocol_validation.pck"


def _run_step(label: str, command: list[str]) -> int:
    print(f"\n[{label}]")
    result = subprocess.run(command, cwd=PROJECT_ROOT, check=False)
    if result.returncode != 0:
        print(f"ÉCHEC — {label} (code {result.returncode})", file=sys.stderr)
    return result.returncode


def main() -> int:
    REPORT_DIRECTORY.mkdir(parents=True, exist_ok=True)
    steps = (
        (
            "Import Godot",
            [
                sys.executable,
                str(PROJECT_ROOT / "run.py"),
                "--headless",
                "--editor",
                "--quit",
            ],
        ),
        (
            "Tests headless",
            [sys.executable, str(PROJECT_ROOT / "test.py")],
        ),
        (
            "Franchissement des portes par les zombies",
            [
                sys.executable,
                str(PROJECT_ROOT / "run.py"),
                "--headless",
                "res://tests/door_navigation_integration.tscn",
            ],
        ),
        (
            "Poursuite des zombies autour des obstacles et dans les passages",
            [
                sys.executable,
                str(PROJECT_ROOT / "run.py"),
                "--headless",
                "res://tests/zombie_navigation_integration.tscn",
            ],
        ),
        (
            "Export de contrôle",
            [
                sys.executable,
                str(PROJECT_ROOT / "run.py"),
                "--headless",
                "--export-pack",
                "Windows Desktop",
                str(EXPORT_PACKAGE),
            ],
        ),
    )

    for label, command in steps:
        exit_code = _run_step(label, command)
        if exit_code != 0:
            return exit_code

    print("\nCONTRÔLE NOX PROTOCOL RÉUSSI")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
