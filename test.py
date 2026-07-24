from __future__ import annotations

import sys

import run


TEST_RUNNER = "res://tests/headless_test_runner.gd"


def main(arguments: list[str] | None = None) -> int:
    test_arguments = sys.argv[1:] if arguments is None else arguments
    return run.main(
        [
            "--headless",
            "--script",
            TEST_RUNNER,
            "--",
            *test_arguments,
        ]
    )


if __name__ == "__main__":
    raise SystemExit(main())
