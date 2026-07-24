from __future__ import annotations

import subprocess
import unittest
from unittest.mock import call, patch

import check


class CheckCommandTests(unittest.TestCase):
    @patch.object(check.subprocess, "run")
    def test_stops_at_first_failure_and_preserves_exit_code(
        self, run_command
    ) -> None:
        run_command.side_effect = [
            subprocess.CompletedProcess(args=[], returncode=0),
            subprocess.CompletedProcess(args=[], returncode=9),
        ]

        exit_code = check.main()

        self.assertEqual(exit_code, 9)
        self.assertEqual(run_command.call_count, 2)
        self.assertEqual(
            run_command.call_args_list,
            [
                call(
                    unittest.mock.ANY,
                    cwd=check.PROJECT_ROOT,
                    check=False,
                ),
                call(
                    unittest.mock.ANY,
                    cwd=check.PROJECT_ROOT,
                    check=False,
                ),
            ],
        )


if __name__ == "__main__":
    unittest.main()
