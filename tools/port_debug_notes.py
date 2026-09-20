from __future__ import annotations

import argparse
import json
import os
from datetime import datetime
from pathlib import Path


SAVE_PATH = Path(os.environ["APPDATA"]) / "Godot" / "app_userdata" / "Nox Protocol" / "port_debug_notes.json"
STATUSES = {"new", "in_analysis", "waiting_validation", "resolved", "blocked"}


def load_notes() -> list[dict]:
    if not SAVE_PATH.exists():
        return []
    raw = json.loads(SAVE_PATH.read_text(encoding="utf-8"))
    notes: list[dict] = []
    for index, item in enumerate(raw):
        if not isinstance(item, dict):
            continue
        content = str(item.get("content", "")).strip()
        if not content:
            continue
        item.setdefault("id", f"legacy_{index}")
        item.setdefault("status", "new")
        item.setdefault("messages", [{"role": "user", "content": content, "created_at": item.get("created_at", "")}])
        notes.append(item)
    return notes


def save_notes(notes: list[dict]) -> None:
    SAVE_PATH.parent.mkdir(parents=True, exist_ok=True)
    SAVE_PATH.write_text(json.dumps(notes, ensure_ascii=False), encoding="utf-8")


def find_note(notes: list[dict], note_id: str) -> dict:
    for note in notes:
        if note["id"] == note_id:
            return note
    raise SystemExit(f"Commentaire introuvable : {note_id}")


def main() -> int:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="action", required=True)
    subparsers.add_parser("list")
    reply = subparsers.add_parser("reply")
    reply.add_argument("id")
    reply.add_argument("message")
    reply.add_argument("--status", choices=STATUSES, default="waiting_validation")
    status = subparsers.add_parser("status")
    status.add_argument("id")
    status.add_argument("value", choices=STATUSES)
    rename = subparsers.add_parser("rename")
    rename.add_argument("id")
    rename.add_argument("title")
    args = parser.parse_args()
    notes = load_notes()
    if args.action == "list":
        print(json.dumps(notes, ensure_ascii=False, indent=2))
        return 0
    note = find_note(notes, args.id)
    if args.action == "reply":
        note["messages"].append({"role": "assistant", "content": args.message, "created_at": datetime.now().isoformat(timespec="seconds")})
        note["status"] = args.status
    elif args.action == "status":
        note["status"] = args.value
    else:
        note["title"] = args.title.strip()[:64]
    save_notes(notes)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
