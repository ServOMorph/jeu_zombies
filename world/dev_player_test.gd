extends Node3D

const STARTUP_SCENE := "res://ui/dev_startup/dev_startup.tscn"
const HUD_UPDATE_INTERVAL_SECONDS := 0.1
const IMPACT_POOL_SIZE := 12
const IMPACT_LIFETIME_SECONDS := 0.12
const STRESS_TEST_WAVE_NUMBER := 5

@onready var player = $Player
@onready var vitals_label: Label = %VitalsLabel
@onready var weapon_label: Label = %WeaponLabel
@onready var hit_marker: Label = %HitMarker
@onready var target = $TargetDummy
@onready var zombie_spawner = $ZombieSpawner
@onready var wave_manager: WaveManager = $WaveManager
@onready var spawn_label: Label = %SpawnLabel
@onready var survival_label: Label = %SurvivalLabel
@onready var defeat_label: Label = %DefeatLabel
@onready var muzzle_flash: MeshInstance3D = $Player/Head/Camera3D/MuzzleFlash
@onready var impact_effects: Node3D = $ImpactEffects
@onready var combat_audio = $CombatAudioFeedback

var _hit_marker_remaining := 0.0
var _muzzle_flash_remaining := 0.0
var _hud_update_elapsed := 0.0
var _impact_pool: Array[MeshInstance3D] = []
var _impact_lifetimes: Array[float] = []
var _impact_pool_cursor := 0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_create_impact_pool()
	_refresh_hud()
	player.weapon_controller.shot_fired.connect(_on_shot_fired)
	player.weapon_controller.melee_swung.connect(_on_melee_swung)
	player.weapon_controller.hit_confirmed.connect(_on_hit_confirmed)
	player.weapon_controller.impact_registered.connect(_on_impact_registered)
	zombie_spawner.zombie_spawned.connect(_on_zombie_spawned)
	zombie_spawner.spawn_deferred.connect(_on_spawn_deferred)
	wave_manager.wave_started.connect(_on_wave_started)
	wave_manager.remaining_zombies_changed.connect(_on_wave_remaining_changed)
	wave_manager.wave_finished.connect(_on_wave_finished)
	wave_manager.waves_completed.connect(_on_waves_completed)
	GameSession.session_ended.connect(_on_session_ended)
	if GameSession.state == GameSession.State.MENU:
		GameSession.start_new_session()
	call_deferred("_start_survival_loop")
	print("NOX_PROTOCOL_DEV_PLAYER_TEST_READY")


func _process(delta: float) -> void:
	_update_transient_effects(delta)
	_hud_update_elapsed += delta
	if _hud_update_elapsed >= HUD_UPDATE_INTERVAL_SECONDS:
		_refresh_hud()
		_hud_update_elapsed = 0.0


func _create_impact_pool() -> void:
	var mesh := SphereMesh.new()
	mesh.radius = 0.06
	mesh.height = 0.12
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color(1.0, 0.56, 0.14, 1.0)
	material.emission_enabled = true
	material.emission = Color(1.0, 0.2, 0.02, 1.0)
	material.emission_energy_multiplier = 3.0
	for _index in IMPACT_POOL_SIZE:
		var impact := MeshInstance3D.new()
		impact.mesh = mesh
		impact.material_override = material
		impact.visible = false
		impact_effects.add_child(impact)
		_impact_pool.append(impact)
		_impact_lifetimes.append(0.0)


func _update_transient_effects(delta: float) -> void:
	_hit_marker_remaining = maxf(0.0, _hit_marker_remaining - delta)
	_muzzle_flash_remaining = maxf(0.0, _muzzle_flash_remaining - delta)
	hit_marker.visible = _hit_marker_remaining > 0.0
	muzzle_flash.visible = _muzzle_flash_remaining > 0.0
	for index in _impact_pool.size():
		if _impact_lifetimes[index] <= 0.0:
			continue
		_impact_lifetimes[index] = maxf(0.0, _impact_lifetimes[index] - delta)
		if _impact_lifetimes[index] == 0.0:
			_impact_pool[index].visible = false


func _refresh_hud() -> void:
	var state := "DÉFAITE" if player.vitals.is_dead else "EN COURS"
	var sprint_state := "ACTIVE" if player.is_sprinting else "REPOS"
	if player.vitals.is_exhausted:
		sprint_state = "ÉPUISÉ"
	vitals_label.text = "Santé : %.0f / %.0f\nEndurance : %.0f / %.0f\nVitesse : %.1f m/s\nCourse : %s\nÉtat : %s" % [
		player.vitals.health,
		player.vitals.max_health,
		player.vitals.stamina,
		player.vitals.max_stamina,
		player.get_horizontal_speed(),
		sprint_state,
		state,
	]
	var ammo: Vector2i = player.weapon_controller.get_current_ammo()
	weapon_label.text = "Arme : %s\nMunitions : %d / %d\nCible : %.0f / %.0f" % [
		player.weapon_controller.get_current_weapon_name(),
		ammo.x,
		ammo.y,
		target.health,
		target.max_health,
	]
	var wave_status := _get_wave_status_text()
	survival_label.text = "Vague : %d / %d\n%s\nZombies : %d / %d" % [
		wave_manager.current_wave_number,
		wave_manager.wave_definitions.size(),
		wave_status,
		zombie_spawner.get_active_zombie_count(),
		zombie_spawner.max_active_zombies,
	]


func _on_shot_fired(_weapon_name: String) -> void:
	_muzzle_flash_remaining = 0.06
	combat_audio.play_shot()


func _on_melee_swung() -> void:
	combat_audio.play_melee()


func _on_hit_confirmed(_damage: float) -> void:
	_hit_marker_remaining = 0.12
	combat_audio.play_hit()


func _on_impact_registered(position: Vector3, normal: Vector3) -> void:
	var impact := _impact_pool[_impact_pool_cursor]
	impact.global_position = position + normal * 0.03
	impact.visible = true
	_impact_lifetimes[_impact_pool_cursor] = IMPACT_LIFETIME_SECONDS
	_impact_pool_cursor = (_impact_pool_cursor + 1) % IMPACT_POOL_SIZE


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ENTER and GameSession.state == GameSession.State.DEFEAT:
		_restart_survival_session()
		get_viewport().set_input_as_handled()
		return
	if (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_ESCAPE
	):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		GameSession.return_to_menu()
		get_tree().change_scene_to_file(STARTUP_SCENE)
		get_viewport().set_input_as_handled()
	elif (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_F6
	):
		player.receive_damage(25.0)
		get_viewport().set_input_as_handled()
	elif (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_F7
	):
		target.reset()
		get_viewport().set_input_as_handled()
	elif (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_F8
	):
		wave_manager.start_next_wave(player)
		get_viewport().set_input_as_handled()
	elif (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_F9
	):
		wave_manager.start_wave_for_test(2, player)
		get_viewport().set_input_as_handled()
	elif (
		event is InputEventKey
		and event.pressed
		and not event.echo
		and event.keycode == KEY_F10
	):
		_start_stress_test()
		get_viewport().set_input_as_handled()


func _on_zombie_spawned(_zombie: Node3D, spawn_point: Node3D, used_fallback: bool) -> void:
	var source := "repli" if used_fallback else "zone demandée"
	spawn_label.text = "Apparition : %s (%s)\nZombies actifs : %d / %d" % [
		spawn_point.name,
		source,
		zombie_spawner.get_active_zombie_count(),
		zombie_spawner.max_active_zombies,
	]


func _on_spawn_deferred(_zone_id: String) -> void:
	spawn_label.text = "Apparition différée : aucun point valide ou plafond atteint\nZombies actifs : %d / %d" % [
		zombie_spawner.get_active_zombie_count(),
		zombie_spawner.max_active_zombies,
	]


func _on_wave_started(wave_number: int, _definition: WaveDefinition) -> void:
	spawn_label.text = "Vague %d en cours\nZombies restants : %d" % [
		wave_number,
		wave_manager.get_remaining_zombie_count(),
	]


func _on_wave_remaining_changed(remaining_count: int) -> void:
	spawn_label.text = "Vague %d en cours\nZombies restants : %d" % [
		wave_manager.current_wave_number,
		remaining_count,
	]


func _on_waves_completed() -> void:
	spawn_label.text = "Cinq vagues terminées\nSurvie validée"


func _on_session_ended(final_state: int) -> void:
	if final_state != GameSession.State.DEFEAT:
		return
	wave_manager.stop()
	zombie_spawner.deactivate_all()
	defeat_label.visible = true
	spawn_label.text = "Défaite\nEntrée : recommencer une session neuve"


func _start_survival_loop() -> void:
	if GameSession.state != GameSession.State.PLAYING:
		return
	wave_manager.start_next_wave(player)


func _restart_survival_session() -> void:
	if not GameSession.start_new_session():
		return
	get_tree().reload_current_scene()


func _start_stress_test() -> void:
	if not OS.is_debug_build() or GameSession.state != GameSession.State.PLAYING:
		return
	wave_manager.stop()
	zombie_spawner.deactivate_all()
	if wave_manager.start_wave_for_test(STRESS_TEST_WAVE_NUMBER, player):
		spawn_label.text = "Test de charge : vague %d\nPlafond : %d zombies" % [
			STRESS_TEST_WAVE_NUMBER,
			zombie_spawner.max_active_zombies,
		]


func _get_wave_status_text() -> String:
	match wave_manager.state:
		WaveManager.State.SPAWNING:
			return "Apparitions en cours"
		WaveManager.State.WAITING_FOR_CLEAR:
			return "Éliminez les derniers zombies"
		WaveManager.State.INTERMISSION:
			return "Pause : %.1f s" % wave_manager.get_intermission_remaining_seconds()
		WaveManager.State.COMPLETED:
			return "Survie terminée"
		_:
			return "En attente"


func _on_wave_finished(wave_number: int) -> void:
	spawn_label.text = "Vague %d terminée\nPause : %.1f s" % [
		wave_number,
		wave_manager.get_intermission_remaining_seconds(),
	]
