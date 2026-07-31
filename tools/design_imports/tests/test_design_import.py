from __future__ import annotations

import json
import struct
import tempfile
import unittest
from pathlib import Path

from tools.design_imports import design_import as tool


class DesignImportTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.root = Path(self.temporary.name)
        self.registry_path = self.root / "_docs/design_imports/registry.json"
        self.source = self.root / "DESIGN/lot/exports/asset.glb"
        self.source.parent.mkdir(parents=True)
        self.source.write_bytes(b"source-v1")

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def command(self, *arguments: str) -> int:
        return tool.main(["--repo", str(self.root), *arguments])

    def test_scan_and_plan_are_idempotent(self) -> None:
        arguments = ("scan", "--lot", "lot", "--source", "DESIGN/lot/exports", "--target", "assets/models")
        self.assertEqual(self.command(*arguments), 0)
        first_registry = self.registry_path.read_bytes()
        self.assertEqual(self.command(*arguments), 0)
        self.assertEqual(self.registry_path.read_bytes(), first_registry)
        run_id = "2026-07-31T151903Z_lot_12345678"
        self.assertEqual(self.command("plan", "--run-id", run_id, "--output", "run/plan.json"), 0)
        first_plan = (self.root / "run/plan.json").read_bytes()
        self.assertEqual(self.command("plan", "--run-id", run_id, "--output", "run/plan.json"), 0)
        self.assertEqual((self.root / "run/plan.json").read_bytes(), first_plan)

    def test_unapproved_design_cannot_modify_target(self) -> None:
        self.command("scan", "--lot", "lot", "--source", "DESIGN/lot/exports", "--target", "assets/models")
        self.command("preflight")
        run_id = "2026-07-31T151903Z_lot_12345678"
        self.command("plan", "--run-id", run_id, "--output", "run/plan.json")
        target = self.root / "assets/models/asset.glb"
        target.parent.mkdir(parents=True)
        target.write_bytes(b"original")
        with self.assertRaises(tool.DesignImportError):
            self.command("apply", "--plan", "run/plan.json")
        self.assertEqual(target.read_bytes(), b"original")

    def test_archive_apply_verify_and_rollback(self) -> None:
        self.command("scan", "--lot", "lot", "--source", "DESIGN/lot/exports", "--target", "assets/models")
        self.command("preflight")
        registry = tool.load_registry(self.registry_path, self.root)
        entry = registry["designs"][0]
        tool.transition(entry, "approuve")
        entry["decision"] = "approuve"
        entry["decision_at"] = "2026-07-31T15:19:03Z"
        tool.save_registry(self.registry_path, registry, self.root)
        target = self.root / "assets/models/asset.glb"
        target.parent.mkdir(parents=True)
        target.write_bytes(b"original")
        run_id = "2026-07-31T151903Z_lot_12345678"
        self.command("plan", "--run-id", run_id, "--output", "run/plan.json")
        self.command("archive", "--plan", "run/plan.json")
        self.command("archive", "--plan", "run/plan.json")
        self.command("apply", "--plan", "run/plan.json")
        self.command("apply", "--plan", "run/plan.json")
        self.assertEqual(target.read_bytes(), b"source-v1")
        self.command("verify")
        self.command("rollback", "--run-id", run_id)
        self.assertEqual(target.read_bytes(), b"original")

    def test_registry_rejects_dangerous_path_and_duplicate_id(self) -> None:
        entry = tool.base_entry(self.root, "lot", self.source, self.source.parent, None, "proprietaire")
        entry["target_paths"] = ["../outside.glb"]
        with self.assertRaises(tool.DesignImportError):
            tool.validate_registry({"schema_version": 1, "updated_at": None, "designs": [entry]}, self.root)
        entry["target_paths"] = []
        duplicate = dict(entry)
        duplicate["source_path"] = "DESIGN/lot/exports/other.glb"
        with self.assertRaises(tool.DesignImportError):
            tool.validate_registry({"schema_version": 1, "updated_at": None, "designs": [entry, duplicate]}, self.root)

    def test_invalid_transition_is_rejected(self) -> None:
        entry = tool.base_entry(self.root, "lot", self.source, self.source.parent, None, "proprietaire")
        with self.assertRaises(tool.DesignImportError):
            tool.transition(entry, "importe")

    def test_report_is_deterministic(self) -> None:
        self.command("scan", "--lot", "lot", "--source", "DESIGN/lot/exports")
        registry = tool.load_registry(self.registry_path, self.root)
        first_report = tool.report(registry)
        second_report = tool.report(registry)
        self.assertEqual(first_report, second_report)
        self.assertEqual(first_report["total"], 1)
        self.assertEqual(first_report["statuses"]["detecte"], 1)

    def test_inventory_classifies_missing_target_and_renders_plan(self) -> None:
        document = json.dumps({"asset": {"version": "2.0"}, "nodes": [], "meshes": []}).encode("utf-8")
        padded = document + b" " * ((4 - len(document) % 4) % 4)
        self.source.write_bytes(struct.pack("<4sII", b"glTF", 2, 20 + len(padded)) + struct.pack("<I4s", len(padded), b"JSON") + padded)
        self.command("scan", "--lot", "lot", "--source", "DESIGN/lot/exports", "--target", "assets/models")
        run_id = "2026-07-31T151903Z_lot_12345678"
        self.assertEqual(self.command("inventory", "--run-id", run_id, "--output", "run/inventory.json", "--plan-output", "run/plan_import.md"), 0)
        inventory = json.loads((self.root / "run/inventory.json").read_text(encoding="utf-8"))
        self.assertEqual(inventory["classification_counts"], {"ajout": 1})
        self.assertIn("### lot:asset", (self.root / "run/plan_import.md").read_text(encoding="utf-8"))

    def test_approval_requires_the_exact_plan_hash(self) -> None:
        self.command("scan", "--lot", "lot", "--source", "DESIGN/lot/exports", "--target", "assets/models")
        self.command("preflight")
        run_id = "2026-07-31T151903Z_lot_12345678"
        self.command("plan", "--run-id", run_id, "--output", "run/plan.json")
        with self.assertRaises(tool.DesignImportError):
            self.command("approve", "--plan", "run/plan.json", "--plan-sha256", "0" * 64)
        plan_hash = tool.sha256_file(self.root / "run/plan.json")
        self.assertEqual(self.command("approve", "--plan", "run/plan.json", "--plan-sha256", plan_hash), 0)
        registry = tool.load_registry(self.registry_path, self.root)
        self.assertEqual(registry["designs"][0]["design_status"], "approuve")
        self.assertEqual(len(list(tool.plan_entries(registry, tool.load_plan(self.root / "run/plan.json", self.root)))), 1)

    def test_registry_digest_is_unchanged_by_approval_state(self) -> None:
        self.command("scan", "--lot", "lot", "--source", "DESIGN/lot/exports", "--target", "assets/models")
        registry = tool.load_registry(self.registry_path, self.root)
        before = tool.registry_digest(registry)
        entry = registry["designs"][0]
        tool.transition(entry, "precontrole_ok")
        tool.transition(entry, "approuve")
        entry["decision"] = "approuve"
        entry["decision_at"] = "2026-07-31T15:19:03Z"
        self.assertEqual(tool.registry_digest(registry), before)


if __name__ == "__main__":
    unittest.main()
