extends Node

const SAVE_PATH := "user://port_debug_notes.json"

signal note_added(note: Dictionary)
signal note_updated(note: Dictionary)


func add_note(content: String) -> bool:
	var normalized := content.strip_edges()
	if normalized.is_empty():
		return false
	var notes := get_notes()
	var note := {
		"id": _new_id(notes),
		"created_at": Time.get_datetime_string_from_system(),
		"content": normalized,
		"title": normalized.left(64),
		"status": "new",
		"messages": [{"role": "user", "created_at": Time.get_datetime_string_from_system(), "content": normalized}],
	}
	notes.append(note)
	if not _save(notes):
		return false
	note_added.emit(note)
	return true


func add_message(note_id: String, role: String, content: String, status := "") -> bool:
	var normalized := content.strip_edges()
	if normalized.is_empty() or (role != "user" and role != "assistant"):
		return false
	var notes := get_notes()
	for index in notes.size():
		var note := notes[index] as Dictionary
		if str(note.get("id", "")) != note_id:
			continue
		var messages := note.get("messages", []) as Array
		messages.append({"role": role, "created_at": Time.get_datetime_string_from_system(), "content": normalized})
		note["messages"] = messages
		if not status.is_empty():
			note["status"] = status
		notes[index] = note
		if not _save(notes):
			return false
		note_updated.emit(note)
		return true
	return false


func set_status(note_id: String, status: String) -> bool:
	if not ["new", "in_analysis", "waiting_validation", "resolved", "blocked"].has(status):
		return false
	var notes := get_notes()
	for index in notes.size():
		var note := notes[index] as Dictionary
		if str(note.get("id", "")) != note_id:
			continue
		note["status"] = status
		notes[index] = note
		if not _save(notes):
			return false
		note_updated.emit(note)
		return true
	return false


func rename_note(note_id: String, title: String) -> bool:
	var normalized := title.strip_edges()
	if normalized.is_empty():
		return false
	var notes := get_notes()
	for index in notes.size():
		var note := notes[index] as Dictionary
		if str(note.get("id", "")) != note_id:
			continue
		note["title"] = normalized.left(64)
		notes[index] = note
		if not _save(notes):
			return false
		note_updated.emit(note)
		return true
	return false


func get_notes() -> Array:
	if not FileAccess.file_exists(SAVE_PATH):
		return []
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return []
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if not parsed is Array:
		return []
	return _normalize_notes(parsed)


func get_note(note_id: String) -> Dictionary:
	for note: Dictionary in get_notes():
		if str(note.get("id", "")) == note_id:
			return note
	return {}


func _normalize_notes(raw_notes: Array) -> Array:
	var normalized: Array = []
	for index in raw_notes.size():
		var raw = raw_notes[index]
		if not raw is Dictionary:
			continue
		var note := (raw as Dictionary).duplicate(true)
		var content := str(note.get("content", "")).strip_edges()
		if content.is_empty():
			continue
		if str(note.get("id", "")).is_empty():
			note["id"] = "legacy_%d" % index
		if str(note.get("title", "")).strip_edges().is_empty():
			note["title"] = content.left(64)
		if not ["new", "in_analysis", "waiting_validation", "resolved", "blocked"].has(str(note.get("status", ""))):
			note["status"] = "new"
		if not note.get("messages", []) is Array or (note["messages"] as Array).is_empty():
			note["messages"] = [{"role": "user", "created_at": str(note.get("created_at", "")), "content": content}]
		normalized.append(note)
	return normalized


func _new_id(notes: Array) -> String:
	return "note_%d_%d" % [Time.get_unix_time_from_system(), notes.size()]


func _save(notes: Array) -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(notes))
	file.close()
	return true
