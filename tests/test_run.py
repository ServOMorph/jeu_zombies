from __future__ import annotations

from pathlib import Path
import subprocess
import unittest
from unittest.mock import patch

import run


class RunLauncherTests(unittest.TestCase):
    def test_forwards_arguments_and_preserves_exit_code(self) -> None:
        fake_godot = Path("C:/outils/godot_console.exe")
        godot_result = subprocess.CompletedProcess(args=[], returncode=17)
        arguments = ["--headless", "--quit-after", "3"]

        with (
            patch.object(run, "find_godot", return_value=fake_godot),
            patch.object(run.subprocess, "run", return_value=godot_result) as launch,
        ):
            exit_code = run.main(arguments)

        self.assertEqual(exit_code, 17)
        launch.assert_called_once_with(
            [
                str(fake_godot),
                "--path",
                str(run.PROJECT_ROOT),
                *arguments,
            ],
            check=False,
        )

    def test_rejects_a_missing_configured_executable(self) -> None:
        with patch.dict(run.os.environ, {run.GODOT_ENV_VAR: "Z:/godot_absent.exe"}):
            self.assertEqual(run.main(["--version"]), 1)

    def test_rejects_a_missing_project_file(self) -> None:
        with patch.object(run, "PROJECT_FILE", Path("Z:/projet_absent/project.godot")):
            self.assertEqual(run.main(["--headless"]), 1)


if __name__ == "__main__":
    unittest.main()
