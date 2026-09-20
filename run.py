from __future__ import annotations

import os
from pathlib import Path
import shutil
import subprocess
import sys
import time
from ctypes import WINFUNCTYPE, WinDLL, byref, c_int, c_size_t, create_string_buffer
from ctypes import wintypes


PROJECT_ROOT = Path(__file__).resolve().parent
PROJECT_FILE = PROJECT_ROOT / "project.godot"
GODOT_ENV_VAR = "GODOT_BIN"
MINIMUM_PYTHON = (3, 10)
VIRTUAL_DESKTOP_NAME = "Agents"
VIRTUAL_DESKTOP_ACCESSOR = PROJECT_ROOT / "tools" / "VirtualDesktopAccessor.dll"


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


def _load_virtual_desktop_accessor() -> WinDLL | None:
	if not VIRTUAL_DESKTOP_ACCESSOR.is_file():
		return None
	try:
		return WinDLL(str(VIRTUAL_DESKTOP_ACCESSOR))
	except OSError as error:
		print(f"Accès aux bureaux virtuels indisponible : {error}", file=sys.stderr)
		return None


def _find_virtual_desktop_number(accessor: WinDLL, name: str) -> int | None:
	get_count = accessor.GetDesktopCount
	get_count.restype = c_int
	get_name = accessor.GetDesktopName
	get_name.argtypes = [c_int, wintypes.LPSTR, c_size_t]
	get_name.restype = c_int
	for desktop_number in range(get_count()):
		buffer = create_string_buffer(512)
		if get_name(desktop_number, buffer, len(buffer)) != -1:
			if buffer.value.decode("utf-8", errors="replace") == name:
				return desktop_number
	return None


def _find_window_for_process(process_id: int, timeout_seconds: float = 8.0) -> int | None:
	user32 = WinDLL("user32", use_last_error=True)
	enum_windows = user32.EnumWindows
	enum_windows.argtypes = [WINFUNCTYPE(wintypes.BOOL, wintypes.HWND, wintypes.LPARAM), wintypes.LPARAM]
	enum_windows.restype = wintypes.BOOL
	get_process_id = user32.GetWindowThreadProcessId
	get_process_id.argtypes = [wintypes.HWND, wintypes.LPDWORD]
	get_process_id.restype = wintypes.DWORD
	is_visible = user32.IsWindowVisible
	is_visible.argtypes = [wintypes.HWND]
	is_visible.restype = wintypes.BOOL
	deadline = time.monotonic() + timeout_seconds
	while time.monotonic() < deadline:
		window_handles: list[int] = []

		@WINFUNCTYPE(wintypes.BOOL, wintypes.HWND, wintypes.LPARAM)
		def inspect_window(hwnd: int, _lparam: int) -> bool:
			owner_process = wintypes.DWORD()
			get_process_id(hwnd, byref(owner_process))
			if owner_process.value == process_id and is_visible(hwnd):
				window_handles.append(hwnd)
				return False
			return True

		enum_windows(inspect_window, 0)
		if window_handles:
			return window_handles[0]
		time.sleep(0.1)
	return None


def _launch_in_virtual_desktop(command: list[str]) -> int:
	accessor = _load_virtual_desktop_accessor()
	if accessor is None:
		return subprocess.run(command, check=False).returncode
	desktop_number = _find_virtual_desktop_number(accessor, VIRTUAL_DESKTOP_NAME)
	if desktop_number is None:
		print(f"Bureau virtuel introuvable : {VIRTUAL_DESKTOP_NAME}", file=sys.stderr)
		return subprocess.run(command, check=False).returncode
	go_to_desktop = accessor.GoToDesktopNumber
	go_to_desktop.argtypes = [c_int]
	go_to_desktop.restype = c_int
	if go_to_desktop(desktop_number) == -1:
		print(f"Impossible d’ouvrir le bureau virtuel : {VIRTUAL_DESKTOP_NAME}", file=sys.stderr)
	process = subprocess.Popen(command)
	window_handle = _find_window_for_process(process.pid)
	if window_handle is not None:
		move_window = accessor.MoveWindowToDesktopNumber
		move_window.argtypes = [wintypes.HWND, c_int]
		move_window.restype = c_int
		if move_window(window_handle, desktop_number) == -1:
			print("La fenêtre Godot n’a pas pu être ancrée au bureau virtuel.", file=sys.stderr)
	else:
		print("Fenêtre Godot non détectée à temps pour l’ancrer au bureau virtuel.", file=sys.stderr)
	return process.wait()


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
        if "--headless" in forwarded_arguments:
            return subprocess.run(command, check=False).returncode
        return _launch_in_virtual_desktop(command)
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
