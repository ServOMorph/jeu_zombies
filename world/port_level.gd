extends Node3D

const STARTUP_SCENE := "res://ui/main_menu/main_menu.tscn"
const MAX_WAVES := 10
const RESTART_REQUEST_PATH := "user://port_restart_request.json"

@onready var player: PlayerController = $Player
@onready var blockout: PortBlockout = $PortBlockout
@onready var zombie_spawner: ZombieSpawner = $ZombieSpawner
@onready var wave_manager: WaveManager = $WaveManager
@onready var defense_wave_manager: WaveManager = $DefenseWaveManager
@onready var extraction_controller: PortExtractionController = $ExtractionController
@onready var extraction_terminal: PortExtractionTerminal = $ExtractionTerminal
@onready var game_hud: GameHud = $GameHud
@onready var port_status: Label = %PortStatus
@onready var extraction_status: Label = %ExtractionStatus
@onready var end_label: Label = %EndLabel
@onready var combat_audio: CombatAudioFeedback = $CombatAudioFeedback

var _target_wave := 3
var _victory_recorded := false
var _dev_panel: PanelContainer
var _dev_toggle: Button
var _dev_tabs: TabContainer
var _dev_inputs: Dictionary = {}
var _debug_note_input: TextEdit
var _debug_note_status: Label
var _debug_recent_notes_list: ItemList
var _debug_notes_list: ItemList
var _debug_thread: RichTextLabel
var _debug_reply_input: TextEdit
var _selected_debug_note_id := ""
var _flight_enabled := false
var _flight_button: Button
var _screenshot_mode: OptionButton
var _restart_confirmation: ConfirmationDialog
var _next_restart_request_check_ms := 0
var _damage_flash: ColorRect
var _last_player_health := 0.0
var _dev_drag_active := false
var _dev_drag_offset := Vector2.ZERO


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_set_gameplay_process_mode()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	blockout.create_zombie_spawn_points()
	player.global_position = blockout.get_player_spawn()
	_target_wave = PortProgress.get_target_wave()
	_build_normal_waves()
	extraction_terminal.price_credits = int(PortBalance.get_value("extraction_price"))
	extraction_controller.configure(player, extraction_terminal.global_position, 8.0)
	wave_manager.wave_finished.connect(_on_normal_wave_finished)
	wave_manager.waves_completed.connect(_on_target_reached)
	wave_manager.remaining_zombies_changed.connect(_on_wave_remaining_changed)
	zombie_spawner.zombie_spawned.connect(_on_zombie_spawned)
	extraction_terminal.extraction_requested.connect(_on_extraction_requested)
	extraction_controller.countdown_changed.connect(_on_extraction_countdown_changed)
	extraction_controller.extraction_succeeded.connect(_on_extraction_succeeded)
	GameSession.session_ended.connect(_on_session_ended)
	PortBalance.value_changed.connect(_on_balance_changed)
	PortBalance.reset.connect(_on_balance_reset)
	game_hud.configure(player, wave_manager, player.get_node("Head/Camera3D/InteractionController"))
	player.weapon_controller.shot_fired.connect(_on_shot_fired)
	player.weapon_controller.melee_swung.connect(_on_melee_swung)
	player.weapon_controller.hit_confirmed.connect(_on_hit_confirmed)
	_create_dev_menu()
	_create_restart_confirmation()
	_create_damage_flash()
	_last_player_health = player.vitals.health
	player.vitals.health_changed.connect(_on_player_health_changed)
	if GameSession.start_new_session():
		call_deferred("_start_normal_waves")
	_update_port_status()


func _set_gameplay_process_mode() -> void:
	for node: Node in [
		player,
		blockout,
		zombie_spawner,
		wave_manager,
		defense_wave_manager,
		extraction_controller,
		extraction_terminal,
		game_hud,
	]:
		node.process_mode = Node.PROCESS_MODE_PAUSABLE


func _input(event: InputEvent) -> void:
	if not OS.is_debug_build() or not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.keycode == KEY_F3:
		_toggle_dev_menu()
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_ESCAPE and not _is_dev_menu_open():
		GameSession.return_to_menu()
		get_tree().change_scene_to_file(STARTUP_SCENE)
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	_check_restart_request()
	if not _flight_enabled or get_tree().paused or GameSession.state != GameSession.State.PLAYING:
		return
	var camera := player.get_node("Head/Camera3D") as Camera3D
	var direction := Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction -= camera.global_transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += camera.global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= camera.global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += camera.global_transform.basis.x
	if Input.is_action_pressed("jump"):
		direction.y += 1.0
	if Input.is_action_pressed("crouch"):
		direction.y -= 1.0
	if direction.length_squared() > 0.0:
		var speed := 24.0 if Input.is_action_pressed("sprint") else 12.0
		player.global_position += direction.normalized() * speed * delta


func _create_restart_confirmation() -> void:
	_restart_confirmation = ConfirmationDialog.new()
	_restart_confirmation.title = "Traitement des commentaires terminé"
	_restart_confirmation.dialog_text = "Codex va fermer puis relancer le jeu pour appliquer les modifications."
	_restart_confirmation.ok_button_text = "OK"
	_restart_confirmation.cancel_button_text = "Annuler"
	_restart_confirmation.always_on_top = true
	_restart_confirmation.process_mode = Node.PROCESS_MODE_ALWAYS
	_restart_confirmation.confirmed.connect(_confirm_restart)
	_restart_confirmation.canceled.connect(_cancel_restart)
	add_child(_restart_confirmation)


func _check_restart_request() -> void:
	if Time.get_ticks_msec() < _next_restart_request_check_ms:
		return
	_next_restart_request_check_ms = Time.get_ticks_msec() + 1000
	if _restart_confirmation == null or _restart_confirmation.visible or not FileAccess.file_exists(RESTART_REQUEST_PATH):
		return
	var file := FileAccess.open(RESTART_REQUEST_PATH, FileAccess.READ)
	if file == null:
		return
	var request = JSON.parse_string(file.get_as_text())
	file.close()
	if request is Dictionary and str((request as Dictionary).get("state", "")) == "pending":
		_restart_confirmation.popup_centered()


func _confirm_restart() -> void:
	var helper_path := ProjectSettings.globalize_path("res://tools/port_relauncher.py")
	var helper_pid := OS.create_process("python", [helper_path, str(OS.get_process_id())], false)
	if helper_pid <= 0:
		_write_restart_state("confirmed")
		push_error("Impossible de lancer le redémarrage automatique du Port.")
		return
	_write_restart_state("launching")
	get_tree().quit()


func _cancel_restart() -> void:
	_write_restart_state("cancelled")


func _write_restart_state(state: String) -> void:
	var file := FileAccess.open(RESTART_REQUEST_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify({"state": state}))
	file.close()


func _create_damage_flash() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 30
	layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(layer)
	_damage_flash = ColorRect.new()
	_damage_flash.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_damage_flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_damage_flash.color = Color(0.85, 0.03, 0.01, 0.0)
	layer.add_child(_damage_flash)


func _on_player_health_changed(current_health: float, _maximum_health: float) -> void:
	if current_health < _last_player_health and _damage_flash != null:
		_damage_flash.color = Color(0.85, 0.03, 0.01, 0.28)
		var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(_damage_flash, "color", Color(0.85, 0.03, 0.01, 0.0), 0.22)
	_last_player_health = current_health


func _build_normal_waves() -> void:
	wave_manager.wave_definitions.clear()
	for wave_number in _target_wave:
		wave_manager.wave_definitions.append(_make_wave_definition(wave_number + 1, false))


func _make_wave_definition(wave_number: int, is_final: bool) -> WaveDefinition:
	var definition := WaveDefinition.new()
	definition.display_name = "Renfort d'extraction" if is_final else "Manche %d" % wave_number
	definition.spawn_zone_id = "port"
	var base_count := int(PortBalance.get_value("wave_start_count")) + (wave_number - 1) * int(PortBalance.get_value("wave_increment"))
	definition.zombie_count = ceili(float(base_count) * 1.5) if is_final else base_count
	definition.health_multiplier = pow(1.0 + PortBalance.get_value("health_per_wave"), wave_number - 1)
	var interval := PortBalance.get_value("spawn_interval")
	definition.spawn_interval_seconds = interval / (1.0 + PortBalance.get_value("final_spawn_speed_bonus")) if is_final else interval
	return definition


func _start_normal_waves() -> void:
	if GameSession.state == GameSession.State.PLAYING:
		wave_manager.start_next_wave(player)


func _on_normal_wave_finished(wave_number: int) -> void:
	if wave_number < _target_wave:
		wave_manager.wave_definitions[wave_number] = _make_wave_definition(wave_number + 1, false)
		_update_port_status()


func _on_wave_remaining_changed(_remaining_count: int) -> void:
	_update_port_status()


func _on_target_reached() -> void:
	extraction_terminal.set_available(true)
	port_status.text = "Manche cible %d atteinte\nRejoignez l'extraction" % _target_wave


func _on_extraction_requested() -> void:
	var final_wave := _make_wave_definition(_target_wave, true)
	if not extraction_controller.start(final_wave):
		extraction_terminal.set_available(true)
		return
	extraction_status.visible = true
	_update_port_status()


func _on_extraction_countdown_changed(remaining_seconds: float, is_paused: bool) -> void:
	extraction_status.text = "EXTRACTION : %d s%s" % [int(remaining_seconds), " — EN PAUSE" if is_paused else ""]


func _on_extraction_succeeded() -> void:
	if _victory_recorded:
		return
	_victory_recorded = true
	var next_target := PortProgress.record_victory()
	end_label.text = "EXTRACTION RÉUSSIE\nProchain objectif : manche %d\nEntrée : accueil" % next_target
	end_label.visible = true
	GameSession.finish_session(GameSession.State.VICTORY)


func _on_zombie_spawned(zombie: ZombieStandard, _spawn_point: Node3D, _used_fallback: bool) -> void:
	zombie.definition.credit_reward = int(PortBalance.get_value("zombie_reward"))
	if not zombie.reward_granted.is_connected(_on_zombie_reward_granted):
		zombie.reward_granted.connect(_on_zombie_reward_granted)


func _on_zombie_reward_granted(credits: int) -> void:
	GameSession.add_credits(credits)


func _on_shot_fired(weapon_name: String) -> void:
	var definition = player.weapon_controller.get_current_definition()
	if definition == null:
		combat_audio.play_shot()
		return
	combat_audio.play_weapon_shot(weapon_name, definition.shot_tone_frequency, definition.shot_tone_duration_seconds, definition.shot_tone_amplitude)


func _on_melee_swung() -> void:
	combat_audio.play_melee()


func _on_hit_confirmed(_damage: float) -> void:
	combat_audio.play_hit()


func _on_balance_changed(key: String, _value: float) -> void:
	blockout.apply_balance(key)
	if key == "extraction_price":
		extraction_terminal.price_credits = int(PortBalance.get_value(key))
	if key == "spawn_interval" or key == "final_spawn_speed_bonus":
		_update_active_spawn_interval(wave_manager, false)
		_update_active_spawn_interval(defense_wave_manager, true)


func _update_active_spawn_interval(manager: WaveManager, is_final: bool) -> void:
	var index := manager.current_wave_number - 1
	if index < 0 or index >= manager.wave_definitions.size():
		return
	var interval := PortBalance.get_value("spawn_interval")
	manager.wave_definitions[index].spawn_interval_seconds = interval / (1.0 + PortBalance.get_value("final_spawn_speed_bonus")) if is_final else interval


func _on_session_ended(final_state: int) -> void:
	if final_state == GameSession.State.DEFEAT:
		end_label.text = "DÉFAITE\nObjectif conservé : manche %d\nEntrée : accueil" % _target_wave
		end_label.visible = true
	if final_state == GameSession.State.DEFEAT or final_state == GameSession.State.VICTORY:
		wave_manager.stop()
		defense_wave_manager.stop()
		zombie_spawner.deactivate_all()


func _update_port_status() -> void:
	port_status.text = "PORT — Manche %d / objectif %d\nZombies restants : %d" % [
		wave_manager.current_wave_number,
		_target_wave,
		wave_manager.get_remaining_zombie_count(),
	]


func _create_dev_menu() -> void:
	if not OS.is_debug_build():
		return
	var layer := CanvasLayer.new()
	layer.layer = 20
	layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(layer)
	_dev_panel = PanelContainer.new()
	_dev_panel.visible = false
	_dev_panel.position = Vector2(24, 24)
	_dev_panel.size = Vector2(620, 840)
	_dev_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.035, 0.06, 0.09, 0.97)
	panel_style.border_color = Color(0.12, 0.66, 0.82, 0.9)
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(8)
	panel_style.content_margin_left = 14
	panel_style.content_margin_right = 14
	panel_style.content_margin_top = 12
	panel_style.content_margin_bottom = 12
	_dev_panel.add_theme_stylebox_override("panel", panel_style)
	layer.add_child(_dev_panel)
	_dev_tabs = TabContainer.new()
	_dev_panel.add_child(_dev_tabs)
	var scroll := ScrollContainer.new()
	scroll.name = "Valeurs"
	_dev_tabs.add_child(scroll)
	var content := VBoxContainer.new()
	content.custom_minimum_size.x = 590
	scroll.add_child(content)
	var title := Label.new()
	title.text = "DÉBOGAGE PORT — F3 pour fermer"
	title.add_theme_font_size_override("font_size", 20)
	title.add_theme_color_override("font_color", Color(0.3, 0.85, 1.0, 1.0))
	content.add_child(title)
	title.mouse_filter = Control.MOUSE_FILTER_STOP
	title.gui_input.connect(_on_dev_drag_handle_input)
	var help := Label.new()
	help.text = "Jeu en pause. Modifiez l'équilibrage, créez un fil, ou sélectionnez un fil existant."
	help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	help.add_theme_color_override("font_color", Color(0.72, 0.8, 0.86, 1.0))
	content.add_child(help)
	for key: String in PortBalance.DEFAULTS:
		var row := HBoxContainer.new()
		var label := Label.new()
		label.text = key
		label.custom_minimum_size.x = 220
		row.add_child(label)
		var input := SpinBox.new()
		input.min_value = 0.0
		input.max_value = 100000.0
		input.step = 0.01 if key == "health_per_wave" or key == "final_spawn_speed_bonus" else 1.0
		input.value = PortBalance.get_value(key)
		input.value_changed.connect(func(value: float): PortBalance.set_value(key, value))
		row.add_child(input)
		_dev_inputs[key] = input
		content.add_child(row)
	var reset_button := Button.new()
	reset_button.text = "Réinitialiser l'équilibrage"
	reset_button.pressed.connect(_confirm_balance_reset)
	content.add_child(reset_button)
	var comments_scroll := ScrollContainer.new()
	comments_scroll.name = "Commentaires"
	_dev_tabs.add_child(comments_scroll)
	content = VBoxContainer.new()
	content.custom_minimum_size.x = 590
	comments_scroll.add_child(content)
	var drag_handle := Label.new()
	drag_handle.text = "MAINTENIR ET GLISSER POUR DÉPLACER F3"
	drag_handle.add_theme_color_override("font_color", Color(0.3, 0.85, 1.0, 1.0))
	drag_handle.mouse_filter = Control.MOUSE_FILTER_STOP
	drag_handle.gui_input.connect(_on_dev_drag_handle_input)
	content.add_child(drag_handle)
	_flight_button = Button.new()
	_flight_button.pressed.connect(_toggle_flight_mode)
	content.add_child(_flight_button)
	_update_flight_button()
	var notes_title := Label.new()
	notes_title.text = "1. NOUVEAU COMMENTAIRE"
	notes_title.add_theme_font_size_override("font_size", 16)
	notes_title.add_theme_color_override("font_color", Color(0.38, 1.0, 0.68, 1.0))
	content.add_child(notes_title)
	_debug_note_input = TextEdit.new()
	_debug_note_input.custom_minimum_size = Vector2(0, 80)
	_debug_note_input.placeholder_text = "Décrivez le problème, le contexte et le résultat attendu."
	content.add_child(_debug_note_input)
	var save_note_button := Button.new()
	save_note_button.text = "Créer le commentaire"
	save_note_button.add_theme_color_override("font_color", Color(0.38, 1.0, 0.68, 1.0))
	save_note_button.pressed.connect(_save_debug_note)
	content.add_child(save_note_button)
	var screenshot_title := Label.new()
	screenshot_title.text = "Capture : choisissez sa destination, puis capturez l'écran."
	screenshot_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(screenshot_title)
	_screenshot_mode = OptionButton.new()
	_screenshot_mode.add_item("Nouveau commentaire")
	_screenshot_mode.add_item("Fil sélectionné ci-dessous")
	content.add_child(_screenshot_mode)
	var screenshot_button := Button.new()
	screenshot_button.text = "Capturer l'écran"
	screenshot_button.add_theme_color_override("font_color", Color(0.35, 0.8, 1.0, 1.0))
	screenshot_button.pressed.connect(_capture_debug_screenshot)
	content.add_child(screenshot_button)
	_debug_note_status = Label.new()
	_debug_note_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_debug_note_status.add_theme_color_override("font_color", Color(0.62, 0.78, 0.9, 1.0))
	content.add_child(_debug_note_status)
	var recent_threads_title := Label.new()
	recent_threads_title.text = "2. NOUVEAUX / EN ANALYSE"
	recent_threads_title.add_theme_font_size_override("font_size", 16)
	recent_threads_title.add_theme_color_override("font_color", Color(1.0, 0.64, 0.28, 1.0))
	content.add_child(recent_threads_title)
	_debug_recent_notes_list = ItemList.new()
	_debug_recent_notes_list.custom_minimum_size = Vector2(0, 135)
	_debug_recent_notes_list.item_selected.connect(func(index: int): _on_debug_note_selected(_debug_recent_notes_list, index))
	content.add_child(_debug_recent_notes_list)
	var threads_title := Label.new()
	threads_title.text = "3. EN ATTENTE DE VOTRE VALIDATION"
	threads_title.add_theme_font_size_override("font_size", 16)
	threads_title.add_theme_color_override("font_color", Color(1.0, 0.84, 0.32, 1.0))
	content.add_child(threads_title)
	_debug_notes_list = ItemList.new()
	_debug_notes_list.custom_minimum_size = Vector2(0, 135)
	_debug_notes_list.item_selected.connect(func(index: int): _on_debug_note_selected(_debug_notes_list, index))
	content.add_child(_debug_notes_list)
	_debug_thread = RichTextLabel.new()
	_debug_thread.bbcode_enabled = true
	_debug_thread.fit_content = true
	_debug_thread.custom_minimum_size = Vector2(0, 150)
	_debug_thread.text = "Sélectionnez un fil pour consulter son historique."
	content.add_child(_debug_thread)
	_debug_reply_input = TextEdit.new()
	_debug_reply_input.custom_minimum_size = Vector2(0, 80)
	_debug_reply_input.placeholder_text = "Ajouter une précision au fil sélectionné."
	content.add_child(_debug_reply_input)
	var reply_button := Button.new()
	reply_button.text = "Ajouter ma réponse"
	reply_button.add_theme_color_override("font_color", Color(0.35, 0.8, 1.0, 1.0))
	reply_button.pressed.connect(_save_debug_reply)
	content.add_child(reply_button)
	var validate_button := Button.new()
	validate_button.text = "Valider et retirer ce fil"
	validate_button.add_theme_color_override("font_color", Color(1.0, 0.84, 0.32, 1.0))
	validate_button.pressed.connect(_validate_debug_note)
	content.add_child(validate_button)
	_update_debug_note_status()
	_refresh_debug_threads()
	var confirm := ConfirmationDialog.new()
	confirm.title = "Réinitialiser l'équilibrage"
	confirm.dialog_text = "Restaurer toutes les valeurs par défaut du Port ?"
	confirm.confirmed.connect(func(): PortBalance.reset_defaults())
	layer.add_child(confirm)


func _confirm_balance_reset() -> void:
	for node: Node in get_children():
		if node is CanvasLayer:
			for child: Node in node.get_children():
				if child is ConfirmationDialog:
					(child as ConfirmationDialog).popup_centered()
					return


func _on_balance_reset() -> void:
	for key: String in _dev_inputs:
		(_dev_inputs[key] as SpinBox).value = PortBalance.get_value(key)


func _save_debug_note() -> void:
	if _debug_note_input == null:
		return
	if PortDebugNotes.add_note(_debug_note_input.text):
		_debug_note_input.clear()
	_update_debug_note_status()
	_refresh_debug_threads()


func _save_debug_reply() -> void:
	if _selected_debug_note_id.is_empty() or _debug_reply_input == null:
		return
	if PortDebugNotes.add_message(_selected_debug_note_id, "user", _debug_reply_input.text, "in_analysis"):
		_debug_reply_input.clear()
	_refresh_debug_threads()
	_show_debug_thread(_selected_debug_note_id)


func _validate_debug_note() -> void:
	if _selected_debug_note_id.is_empty():
		return
	if PortDebugNotes.set_status(_selected_debug_note_id, "resolved"):
		_selected_debug_note_id = ""
		_debug_thread.text = ""
		_debug_reply_input.clear()
		_refresh_debug_threads()


func _capture_debug_screenshot() -> void:
	if _dev_panel == null:
		return
	var for_new_comment := _screenshot_mode == null or _screenshot_mode.selected == 0
	if not for_new_comment and _selected_debug_note_id.is_empty():
		_debug_note_status.text = "Sélectionnez un commentaire existant ou choisissez Nouveau commentaire."
		return
	_debug_note_status.text = "Capture en cours…"
	var timestamp := Time.get_unix_time_from_system()
	var capture_owner := "nouveau" if for_new_comment else _selected_debug_note_id
	_dev_panel.visible = false
	await RenderingServer.frame_post_draw
	var directory := "user://debug_screenshots"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(directory))
	var file_path := "%s/%s_%d.png" % [directory, capture_owner, timestamp]
	var error := get_viewport().get_texture().get_image().save_png(ProjectSettings.globalize_path(file_path))
	_dev_panel.visible = true
	if error == OK:
		if for_new_comment:
			var content := _debug_note_input.text.strip_edges()
			if content.is_empty():
				content = "Nouveau commentaire avec capture"
			PortDebugNotes.add_note(content)
			var notes := PortDebugNotes.get_notes()
			if not notes.is_empty():
				_selected_debug_note_id = str((notes.back() as Dictionary).get("id", ""))
			PortDebugNotes.add_message(_selected_debug_note_id, "user", "Capture de debug : %s" % file_path, "in_analysis")
		else:
			PortDebugNotes.add_message(_selected_debug_note_id, "user", "Capture de debug : %s" % file_path, "in_analysis")
		_debug_note_input.clear()
		_refresh_debug_threads()
		_show_debug_thread(_selected_debug_note_id)
		_debug_note_status.text = "Capture enregistrée dans le fil sélectionné."
	else:
		_debug_note_status.text = "Échec de la capture : code %d." % error


func _toggle_flight_mode() -> void:
	_flight_enabled = not _flight_enabled
	player.set_physics_process(not _flight_enabled)
	_update_flight_button()
	if _is_dev_menu_open():
		_toggle_dev_menu()


func _update_flight_button() -> void:
	if _flight_button != null:
		_flight_button.text = "Désactiver le vol d'observation" if _flight_enabled else "Activer le vol d'observation"


func _update_debug_note_status() -> void:
	if _debug_note_status == null:
		return
	var count := 0
	for note: Dictionary in PortDebugNotes.get_notes():
		if str(note.get("status", "new")) != "resolved":
			count += 1
	_debug_note_status.text = "%d fil(s) actif(s) sauvegardé(s) localement." % count


func _refresh_debug_threads() -> void:
	if _debug_recent_notes_list == null or _debug_notes_list == null:
		return
	_debug_recent_notes_list.clear()
	_debug_notes_list.clear()
	var selected_recent_index := -1
	var selected_waiting_index := -1
	for note: Dictionary in PortDebugNotes.get_notes():
		var status := str(note.get("status", "new"))
		if status == "resolved":
			continue
		var target_list := _debug_recent_notes_list if status == "new" or status == "in_analysis" else _debug_notes_list
		var item_index := target_list.add_item("[%s] %s" % [status, str(note.get("title", note.get("content", ""))).left(48)])
		target_list.set_item_metadata(item_index, str(note.get("id", "")))
		if str(note.get("id", "")) == _selected_debug_note_id:
			if target_list == _debug_recent_notes_list:
				selected_recent_index = item_index
			else:
				selected_waiting_index = item_index
	if selected_recent_index >= 0:
		_debug_recent_notes_list.select(selected_recent_index)
	if selected_waiting_index >= 0:
		_debug_notes_list.select(selected_waiting_index)


func _on_debug_note_selected(source_list: ItemList, index: int) -> void:
	if source_list == null:
		return
	_show_debug_thread(str(source_list.get_item_metadata(index)))


func _show_debug_thread(note_id: String) -> void:
	_selected_debug_note_id = note_id
	if _debug_thread == null:
		return
	var note := PortDebugNotes.get_note(note_id)
	if note.is_empty():
		_debug_thread.text = ""
		return
	var lines := PackedStringArray(["[b]Statut : %s[/b]" % str(note.get("status", "new"))])
	for message: Dictionary in note.get("messages", []):
		var author := "Vous" if str(message.get("role", "user")) == "user" else "Codex"
		lines.append("[b]%s[/b] — %s" % [author, str(message.get("content", "")).replace("[", "\\[")])
	var content := "\n\n".join(lines)
	_debug_thread.text = content


func _toggle_dev_menu() -> void:
	if _dev_panel == null:
		return
	_dev_panel.visible = not _dev_panel.visible
	if _dev_panel.visible:
		if _dev_tabs != null:
			_dev_tabs.current_tab = 1
		if GameSession.state == GameSession.State.PLAYING:
			GameSession.toggle_pause()
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		get_tree().paused = false
		if GameSession.state == GameSession.State.PAUSED:
			GameSession.toggle_pause()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_dev_drag_active = false


func _on_dev_drag_handle_input(event: InputEvent) -> void:
	if _dev_panel == null:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_dev_drag_active = event.pressed
		if event.pressed:
			_dev_drag_offset = get_viewport().get_mouse_position() - _dev_panel.position
		get_viewport().set_input_as_handled()
		return
	if event is InputEventMouseMotion and _dev_drag_active:
		var viewport_size := get_viewport().get_visible_rect().size
		var max_position := Vector2(maxf(0.0, viewport_size.x - _dev_panel.size.x), maxf(0.0, viewport_size.y - _dev_panel.size.y))
		_dev_panel.position = (get_viewport().get_mouse_position() - _dev_drag_offset).clamp(Vector2.ZERO, max_position)
		get_viewport().set_input_as_handled()


func _is_dev_menu_open() -> bool:
	return _dev_panel != null and _dev_panel.visible
