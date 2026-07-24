from __future__ import annotations

import os
from pathlib import Path
import shutil
import subprocess
import sys


PROJECT_ROOT = Path(__file__).resolve().parent
PROJECT_FILE = PROJECT_ROOT / "project.godot"
GODOT_ENV_VAR = "GODOT_BIN"
MINIMUM_PYTHON = (3, 10)


def _configured_godot() -> Path | None:
    configured = os.environ.get(GODOT_ENV_VAR)
    if not configured:
        return None

    executable = Path(configured).expanduser()
    if not executable.is_file():
        raise RuntimeError(
            f"{GODOT_ENV_VAR} pointe vers un fichier introuvable : {executable}"
        )
    return executable.resolve()


def _godot_from_path() -> Path | None:
    command_names = (
        "godot_console",
        "godot4_console",
        "godot",
        "godot4",
    )
    for command_name in command_names:
        executable = shutil.which(command_name)
        if executable:
            return Path(executable).resolve()
    return None


def find_godot() -> Path:
    executable = _configured_godot() or _godot_from_path()
    if executable is None:
        raise RuntimeError(
            "Godot 4 est introuvable. Ajoutez son dossier au PATH ou définissez "
            f"{GODOT_ENV_VAR} avec le chemin complet de l'exécutable."
        )
    return executable


def validate_environment() -> None:
    if sys.version_info < MINIMUM_PYTHON:
        required = ".".join(str(part) for part in MINIMUM_PYTHON)
        current = f"{sys.version_info.major}.{sys.version_info.minor}"
        raise RuntimeError(
            f"Python {required} ou plus récent est requis ; version détectée : {current}."
        )
    if not PROJECT_FILE.is_file():
        raise RuntimeError(f"Projet Godot introuvable : {PROJECT_FILE}")


def main(arguments: list[str] | None = None) -> int:
    try:
        validate_environment()
        godot = find_godot()
        forwarded_arguments = sys.argv[1:] if arguments is None else arguments
        command = [
            str(godot),
            "--path",
            str(PROJECT_ROOT),
            *forwarded_arguments,
        ]
        return subprocess.run(command, check=False).returncode
    except RuntimeError as error:
        print(f"Erreur : {error}", file=sys.stderr)
        return 1
    except OSError as error:
        print(f"Erreur lors du lancement de Godot : {error}", file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        return 130


if __name__ == "__main__":
    raise SystemExit(main())
