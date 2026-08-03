extends Node2D

const DESIGN_SIZE := Vector2(1080.0, 1920.0)
const ANDROID_UPDATE_URL := "https://github.com/mariogottling-glitch/spinnen-game/releases/latest/download/web-weaver-android.apk"
const FOREST := Color("#2F6B45")
const DARK_MOSS := Color("#214233")
const LEAF := Color("#6DAE5B")
const CREAM := Color("#F8F5EB")
const HONEY := Color("#F4C556")
const ORANGE := Color("#E86B45")
const SKY := Color("#7DC7E8")
const BERRY := Color("#9B6AA6")

const BACKGROUND_TEXTURE: Texture2D = preload("res://assets/backgrounds/forest-morning-v1.png")
const SPIDER_TEXTURE: Texture2D = preload("res://assets/sprites/spider-v2.png")
const SPIDER_CRAWL_TEXTURE: Texture2D = preload("res://assets/sprites/spider-crawl-sheet-v1.png")
const SPIDER_JUMP_TEXTURE: Texture2D = preload("res://assets/sprites/spider-jump-sheet-v1.png")
const MOTH_TEXTURE: Texture2D = preload("res://assets/sprites/moth-v2.png")
const FLY_TEXTURE: Texture2D = preload("res://assets/sprites/fly-v1.png")
const BEE_TEXTURE: Texture2D = preload("res://assets/sprites/bee-v1.png")
const UPGRADE_ICON_TEXTURES := {
	"strong_silk": preload("res://assets/ui/upgrade-silk-v1.png"),
	"elastic_threads": preload("res://assets/ui/perks/elastic-threads.png"),
	"reinforced_knots": preload("res://assets/ui/perks/reinforced-knots.png"),
	"fortress_core": preload("res://assets/ui/perks/fortress-core.png"),
	"sticky_web": preload("res://assets/ui/upgrade-sticky-v1.png"),
	"deep_glue": preload("res://assets/ui/perks/deep-glue.png"),
	"vibration_sense": preload("res://assets/ui/perks/vibration-sense.png"),
	"perfect_ambush": preload("res://assets/ui/perks/perfect-ambush.png"),
	"quick_legs": preload("res://assets/ui/upgrade-speed-v1.png"),
	"hunting_instinct": preload("res://assets/ui/perks/hunting-instinct.png"),
	"critical_capture": preload("res://assets/ui/perks/critical-capture.png"),
	"venom_bite": preload("res://assets/ui/perks/venom-bite.png"),
	"silk_glands": preload("res://assets/ui/perks/silk-glands.png"),
	"fine_spinning": preload("res://assets/ui/perks/fine-spinning.png"),
	"recycler": preload("res://assets/ui/perks/recycler.png"),
	"architect": preload("res://assets/ui/perks/architect.png"),
	"armored_knots": preload("res://assets/ui/perks/armored-knots.png"),
	"emergency_patch": preload("res://assets/ui/perks/emergency-patch.png"),
	"dew_trap": preload("res://assets/ui/perks/dew-trap.png"),
	"chain_capture": preload("res://assets/ui/perks/chain-capture.png"),
	"predator_focus": preload("res://assets/ui/perks/predator-focus.png"),
	"silk_dash": preload("res://assets/ui/perks/silk-dash.png"),
	"emergency_reserve": preload("res://assets/ui/perks/emergency-reserve.png"),
	"rich_cocoon": preload("res://assets/ui/perks/rich-cocoon.png")
}
const UpgradeDB = preload("res://scripts/upgrade_database.gd")

const PLAY_RECT := Rect2(70.0, 230.0, 940.0, 1390.0)
const JUMP_DURATION := 0.46
const PREVIEW_INTERVAL := 0.82
const INSECT_SPAWN_INTERVAL := 1.25
const WIND_INTERVAL := 8.0
const POUNCE_DURATION := 0.28
const THREAD_GRACE_TIME := 14.0
const THREAD_DECAY_PER_SECOND := 2.0

var anchors: Array[Vector2] = []
var base_anchor_count := 0
var edges: Array[Vector2i] = []
var edge_health: Array[float] = []
var edge_age: Array[float] = []
var insects: Array[Dictionary] = []
var pollen_particles: Array[Dictionary] = []
var capture_flashes: Array[Dictionary] = []

var spider_position := Vector2.ZERO
var current_node := -1
var previous_node := -1
var travel_from := -1
var travel_to := -1
var travel_progress := 0.0
var spider_speed := 260.0
var is_jumping := false
var spider_rotation := 0.0
var spider_anim_time := 0.0
var spider_anim_frame := 0
var jump_progress := 0.0
var jump_start := Vector2.ZERO
var jump_target := Vector2.ZERO
var spider_visual_offset := Vector2.ZERO
var spider_visual_scale := Vector2.ONE
var landing_timer := 0.0
var jump_duration_multiplier := 1.0
var prey_speed_multiplier := 1.0
var strong_silk_level := 0
var sticky_level := 0
var speed_level := 0
var next_insect_id := 1
var pounce_target_id := -1
var upgrade_levels: Dictionary = {}
var offered_upgrades: Array[Dictionary] = []
var thread_decay_multiplier := 1.0
var wind_damage_multiplier := 1.0
var struggle_damage_multiplier := 1.0
var escape_time_multiplier := 1.0
var food_multiplier := 1.0
var double_food_chance := 0.0
var silk_gain_multiplier := 1.0
var thread_cost_multiplier := 1.0
var rare_spawn_bonus := 0.0
var pounce_radius := 165.0
var pounce_duration_multiplier := 1.0
var recycler_level := 0
var architect_level := 0
var boss_damage := 1
var new_thread_health_multiplier := 1.0
var emergency_patch_level := 0
var emergency_patch_cooldown := 0.0
var gnat_reward_level := 0
var chain_capture_chance := 0.0
var active_catch_multiplier := 1.0
var pounce_repair_amount := 0.0
var emergency_reserve_level := 0
var emergency_reserve_used := false
var boss_reward_multiplier := 1.0

var preview_cursor := 0
var preview_anchor := -1
var preview_timer := 0.0
var insect_timer := 0.0
var wind_timer := 0.0
var elapsed_time := 0.0

var thread_strength := 100.0
var capture_radius := 15.0
var integrity := 100.0
var silk := 100.0
var silk_max := 100.0
var food := 0
var xp := 0
var xp_target := 30
var level := 1
var upgrade_open := false
var upgrade_selecting := false
var game_over := false
var hunt_level := 1
var hunt_food := 0
var hunt_goal := 24
var boss_active := false
var level_complete := false
var menu_open := true
var run_started := false
var reduced_motion := false
var menu_transitioning := false

@onready var integrity_label: Label = $HUD/Integrity
@onready var hud: CanvasLayer = $HUD
@onready var threads_label: Label = $HUD/Threads
@onready var food_label: Label = $HUD/Food
@onready var level_label: Label = $HUD/Level
@onready var status_label: Label = $HUD/Status
@onready var hint_label: Label = $HUD/HintBackdrop/HintText
@onready var silk_bar: ProgressBar = $HUD/SilkBar
@onready var xp_bar: ProgressBar = $HUD/XPBar
@onready var silk_label: Label = $HUD/SilkLabel
@onready var xp_label: Label = $HUD/XPLabel
@onready var upgrade_overlay: ColorRect = $HUD/UpgradeOverlay
@onready var upgrade_level_caption: Label = $HUD/UpgradeOverlay/LevelCaption
@onready var upgrade_one: Button = $HUD/UpgradeOverlay/UpgradeOne
@onready var upgrade_two: Button = $HUD/UpgradeOverlay/UpgradeTwo
@onready var upgrade_three: Button = $HUD/UpgradeOverlay/UpgradeThree
@onready var hunt_goal_label: Label = $HUD/HuntGoal
@onready var build_label: Label = $HUD/BuildSummary
@onready var level_complete_overlay: ColorRect = $HUD/LevelCompleteOverlay
@onready var level_complete_title: Label = $HUD/LevelCompleteOverlay/Title
@onready var level_complete_detail: Label = $HUD/LevelCompleteOverlay/Detail
@onready var menu_button: Button = $HUD/MenuButton
@onready var start_menu: CanvasLayer = $StartMenu
@onready var menu_card: Panel = $StartMenu/MenuCard
@onready var menu_hero: TextureRect = $StartMenu/MenuArt
@onready var menu_title: Label = $StartMenu/Title
@onready var play_button: Button = $StartMenu/MenuCard/PlayButton
@onready var how_to_button: Button = $StartMenu/MenuCard/HowToButton
@onready var settings_button: Button = $StartMenu/MenuCard/SettingsButton
@onready var update_button: Button = $StartMenu/MenuCard/UpdateButton
@onready var how_to_overlay: ColorRect = $StartMenu/HowToOverlay
@onready var how_to_back_button: Button = $StartMenu/HowToOverlay/Panel/BackButton
@onready var settings_overlay: ColorRect = $StartMenu/SettingsOverlay
@onready var motion_button: Button = $StartMenu/SettingsOverlay/Panel/MotionButton
@onready var reset_button: Button = $StartMenu/SettingsOverlay/Panel/ResetButton
@onready var settings_back_button: Button = $StartMenu/SettingsOverlay/Panel/BackButton


func _ready() -> void:
	upgrade_one.pressed.connect(_choose_upgrade.bind(0))
	upgrade_two.pressed.connect(_choose_upgrade.bind(1))
	upgrade_three.pressed.connect(_choose_upgrade.bind(2))
	menu_button.pressed.connect(_open_main_menu)
	play_button.pressed.connect(_start_game_from_menu)
	how_to_button.pressed.connect(_show_how_to)
	settings_button.pressed.connect(_show_settings)
	update_button.pressed.connect(_open_android_update)
	how_to_back_button.pressed.connect(_close_menu_panel)
	settings_back_button.pressed.connect(_close_menu_panel)
	motion_button.pressed.connect(_toggle_reduced_motion)
	reset_button.pressed.connect(_prepare_new_run)
	_reset_run()
	_show_main_menu(true)


func _process(delta: float) -> void:
	if menu_open:
		queue_redraw()
		return
	if game_over or upgrade_open or level_complete:
		queue_redraw()
		return

	elapsed_time += delta
	preview_timer += delta
	insect_timer += delta
	wind_timer += delta

	if preview_timer >= PREVIEW_INTERVAL:
		preview_timer = 0.0
		_select_next_preview()

	if insect_timer >= INSECT_SPAWN_INTERVAL and not boss_active:
		insect_timer = 0.0
		_spawn_insect()

	if wind_timer >= WIND_INTERVAL:
		wind_timer = 0.0
		_apply_wind_gust()

	_update_spider(delta)
	_update_spider_animation(delta)
	_update_threads(delta)
	_update_insects(delta)
	_try_emergency_reserve()
	_update_ambience(delta)
	_update_hud()
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if menu_open:
			_close_menu_panel()
		else:
			_open_main_menu()
		return
	if menu_open:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_U:
		if not game_over and not upgrade_open:
			_open_upgrade()
		return
	if OS.is_debug_build() and event is InputEventKey and event.pressed and event.keycode == KEY_B:
		if not game_over and not upgrade_open and not boss_active and not level_complete:
			hunt_food = hunt_goal
			_spawn_boss_moth()
			_update_hud()
		return

	var pressed := false
	var tap_position := Vector2.ZERO
	if event is InputEventScreenTouch:
		pressed = event.pressed
		tap_position = event.position
	elif event is InputEventMouseButton:
		pressed = event.pressed and event.button_index == MOUSE_BUTTON_LEFT
		tap_position = event.position

	if not pressed:
		return
	if game_over:
		_reset_run()
		return
	if level_complete:
		_start_next_hunt_level()
		return
	if not upgrade_open:
		var prey_index := _caught_insect_at(tap_position)
		if prey_index >= 0:
			_pounce_on_insect(prey_index)
		else:
			_jump_to_preview()


func _show_main_menu(initial: bool = false) -> void:
	if menu_transitioning or (not initial and (upgrade_open or level_complete or is_jumping)):
		return
	menu_open = true
	start_menu.visible = true
	hud.visible = false
	menu_button.visible = false
	how_to_overlay.visible = false
	settings_overlay.visible = false
	play_button.text = "WEITERSPIELEN" if run_started else "JAGD BEGINNEN"
	menu_card.pivot_offset = menu_card.size * 0.5
	if reduced_motion:
		menu_card.scale = Vector2.ONE
		menu_card.modulate = Color.WHITE
		menu_hero.modulate = Color.WHITE
		menu_title.modulate = Color.WHITE
		return
	menu_card.scale = Vector2(0.94, 0.94)
	menu_card.modulate = Color(1.0, 1.0, 1.0, 0.0)
	menu_hero.modulate = Color(1.0, 1.0, 1.0, 0.0)
	menu_title.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(menu_card, "scale", Vector2.ONE, 0.38).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(menu_card, "modulate", Color.WHITE, 0.22)
	tween.tween_property(menu_hero, "modulate", Color.WHITE, 0.32).set_delay(0.08)
	tween.tween_property(menu_title, "modulate", Color.WHITE, 0.28).set_delay(0.12)


func _open_main_menu() -> void:
	_show_main_menu(false)


func _start_game_from_menu() -> void:
	if menu_transitioning:
		return
	if not run_started:
		_reset_run()
		run_started = true
	play_button.text = "WEITERSPIELEN"
	_close_menu_panel()
	if reduced_motion:
		start_menu.visible = false
		menu_open = false
		hud.visible = true
		menu_button.visible = true
		return
	menu_transitioning = true
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(menu_card, "scale", Vector2(0.96, 0.96), 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(menu_card, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.18)
	tween.tween_property(menu_hero, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.16)
	tween.tween_property(menu_title, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.16)
	await tween.finished
	start_menu.visible = false
	menu_open = false
	menu_transitioning = false
	hud.visible = true
	menu_button.visible = true
	menu_card.scale = Vector2.ONE
	menu_card.modulate = Color.WHITE
	menu_hero.modulate = Color.WHITE
	menu_title.modulate = Color.WHITE


func _show_how_to() -> void:
	how_to_overlay.visible = true
	settings_overlay.visible = false


func _show_settings() -> void:
	settings_overlay.visible = true
	how_to_overlay.visible = false


func _open_android_update() -> void:
	var error := OS.shell_open(ANDROID_UPDATE_URL)
	if error != OK:
		push_warning("Update-Seite konnte nicht geöffnet werden: %s" % error_string(error))


func _close_menu_panel() -> void:
	how_to_overlay.visible = false
	settings_overlay.visible = false


func _toggle_reduced_motion() -> void:
	reduced_motion = not reduced_motion
	motion_button.text = "BEWEGUNGSEFFEKTE: AUS" if reduced_motion else "BEWEGUNGSEFFEKTE: AN"


func _prepare_new_run() -> void:
	_reset_run()
	run_started = false
	play_button.text = "JAGD BEGINNEN"
	settings_overlay.visible = false
	status_label.text = "NEUE JAGD VORBEREITET"


func _reset_run() -> void:
	anchors.clear()
	edges.clear()
	edge_health.clear()
	edge_age.clear()
	insects.clear()
	pollen_particles.clear()
	capture_flashes.clear()

	var center := PLAY_RECT.get_center()
	anchors = [
		center,
		Vector2(150.0, 360.0), Vector2(390.0, 285.0), Vector2(700.0, 300.0), Vector2(930.0, 430.0),
		Vector2(970.0, 760.0), Vector2(920.0, 1110.0), Vector2(810.0, 1510.0), Vector2(520.0, 1580.0),
		Vector2(220.0, 1500.0), Vector2(105.0, 1190.0), Vector2(115.0, 780.0),
		Vector2(330.0, 620.0), Vector2(745.0, 610.0), Vector2(760.0, 1220.0), Vector2(350.0, 1270.0)
	]
	base_anchor_count = anchors.size()
	current_node = 0
	previous_node = -1
	spider_position = anchors[current_node]
	travel_from = -1
	travel_to = -1
	travel_progress = 0.0
	is_jumping = false
	spider_anim_time = 0.0
	spider_anim_frame = 0
	jump_progress = 0.0
	spider_visual_offset = Vector2.ZERO
	spider_visual_scale = Vector2.ONE
	landing_timer = 0.0
	jump_duration_multiplier = 1.0
	prey_speed_multiplier = 1.0
	strong_silk_level = 0
	sticky_level = 0
	speed_level = 0
	next_insect_id = 1
	pounce_target_id = -1
	upgrade_levels.clear()
	offered_upgrades.clear()
	thread_decay_multiplier = 1.0
	wind_damage_multiplier = 1.0
	struggle_damage_multiplier = 1.0
	escape_time_multiplier = 1.0
	food_multiplier = 1.0
	double_food_chance = 0.0
	silk_gain_multiplier = 1.0
	thread_cost_multiplier = 1.0
	rare_spawn_bonus = 0.0
	pounce_radius = 165.0
	pounce_duration_multiplier = 1.0
	recycler_level = 0
	architect_level = 0
	boss_damage = 1
	new_thread_health_multiplier = 1.0
	emergency_patch_level = 0
	emergency_patch_cooldown = 0.0
	gnat_reward_level = 0
	chain_capture_chance = 0.0
	active_catch_multiplier = 1.0
	pounce_repair_amount = 0.0
	emergency_reserve_level = 0
	emergency_reserve_used = false
	boss_reward_multiplier = 1.0

	thread_strength = 100.0
	capture_radius = 15.0
	spider_speed = 260.0
	spider_rotation = 0.0
	integrity = 100.0
	silk_max = 80.0
	silk = silk_max
	food = 0
	xp = 0
	xp_target = 24
	level = 1
	upgrade_open = false
	upgrade_selecting = false
	game_over = false
	hunt_level = 1
	hunt_food = 0
	hunt_goal = 24
	boss_active = false
	level_complete = false
	elapsed_time = 0.0
	preview_timer = 0.0
	insect_timer = 0.0
	wind_timer = 0.0
	preview_cursor = 11
	_create_pollen()
	upgrade_overlay.visible = false
	level_complete_overlay.visible = false
	status_label.text = "DAS NETZ WÄCHST"
	hint_label.text = "TIPPE, UM ZUM LEUCHTENDEN PUNKT ZU SPRINGEN"
	_select_next_preview()
	_update_hud()
	queue_redraw()


func _jump_to_preview() -> void:
	if is_jumping or preview_anchor < 0:
		return

	var origin := _ensure_anchor(spider_position)
	var destination := preview_anchor
	if origin == destination:
		_select_next_preview()
		return

	var existing_edge := _edge_index(origin, destination)
	var creates_thread := existing_edge < 0 or edge_health[existing_edge] <= 0.0
	var silk_cost := _thread_cost(spider_position, anchors[destination]) if creates_thread else 0.0
	if silk + 0.01 < silk_cost:
		status_label.text = "NICHT GENUG SEIDE"
		hint_label.text = "FANGE INSEKTEN ODER NUTZE KÜRZERE SPRÜNGE"
		return
	if creates_thread:
		silk -= silk_cost
		if existing_edge >= 0:
			edge_health[existing_edge] = thread_strength
			edge_age[existing_edge] = 0.0
		else:
			_add_edge(origin, destination)
			if architect_level > 0:
				_add_architect_support(destination, origin)
	is_jumping = true
	travel_from = -1
	travel_to = -1
	jump_start = spider_position
	jump_target = anchors[destination]
	jump_progress = 0.0
	spider_rotation = (jump_target - jump_start).angle() - PI * 0.5
	status_label.text = "NEUER FADEN"

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(_set_jump_progress, 0.0, 1.0, JUMP_DURATION * jump_duration_multiplier)
	await tween.finished

	previous_node = origin
	current_node = destination
	spider_position = jump_target
	is_jumping = false
	jump_progress = 0.0
	spider_visual_offset = Vector2.ZERO
	spider_visual_scale = Vector2(1.12, 0.84)
	landing_timer = 0.22
	_start_auto_travel()
	_select_next_preview()


func _set_jump_progress(value: float) -> void:
	jump_progress = value
	spider_position = jump_start.lerp(jump_target, value)
	var altitude := sin(value * PI)
	spider_visual_offset = Vector2(0.0, -78.0 * altitude)
	if value < 0.22:
		spider_visual_scale = Vector2(0.90, 1.13)
	elif value < 0.72:
		spider_visual_scale = Vector2(1.08, 0.94)
	else:
		spider_visual_scale = Vector2(1.04, 0.90)
	queue_redraw()


func _update_spider_animation(delta: float) -> void:
	if is_jumping:
		spider_anim_frame = mini(floori(jump_progress * 4.0), 3)
		return

	var pace := clampf(spider_speed / 260.0, 0.75, 1.8)
	spider_anim_time += delta * 7.0 * pace
	spider_anim_frame = floori(spider_anim_time) % 4
	if landing_timer > 0.0:
		landing_timer = maxf(0.0, landing_timer - delta)
		var bounce := landing_timer / 0.22
		spider_visual_scale = Vector2(1.0 + 0.12 * bounce, 1.0 - 0.16 * bounce)
	else:
		spider_visual_scale = Vector2.ONE


func _update_spider(delta: float) -> void:
	if is_jumping:
		return
	if travel_from < 0 or travel_to < 0:
		_start_auto_travel()
		return

	var a := anchors[travel_from]
	var b := anchors[travel_to]
	var distance := maxf(a.distance_to(b), 1.0)
	spider_rotation = (b - a).angle() - PI * 0.5
	travel_progress += (spider_speed / distance) * delta
	spider_position = a.lerp(b, minf(travel_progress, 1.0))

	if travel_progress >= 1.0:
		previous_node = travel_from
		current_node = travel_to
		spider_position = anchors[current_node]
		_start_auto_travel()


func _start_auto_travel() -> void:
	if current_node < 0:
		return
	var neighbors := _neighbors(current_node)
	if neighbors.is_empty():
		travel_from = -1
		travel_to = -1
		return

	var choices: Array[int] = []
	for node in neighbors:
		if node != previous_node:
			choices.append(node)
	if choices.is_empty():
		choices = neighbors

	travel_from = current_node
	travel_to = choices[randi() % choices.size()]
	travel_progress = 0.0


func _neighbors(node: int) -> Array[int]:
	var result: Array[int] = []
	for i in range(edges.size()):
		if edge_health[i] <= 0.0:
			continue
		var edge := edges[i]
		if edge.x == node:
			result.append(edge.y)
		elif edge.y == node:
			result.append(edge.x)
	return result


func _ensure_anchor(position: Vector2) -> int:
	for i in range(anchors.size()):
		if anchors[i].distance_to(position) < 12.0:
			return i
	var index := anchors.size()
	anchors.append(position)
	if travel_from >= 0:
		_add_edge(index, travel_from)
	if travel_to >= 0:
		_add_edge(index, travel_to)
	return index


func _add_edge(a: int, b: int) -> void:
	if a == b:
		return
	for edge in edges:
		if (edge.x == a and edge.y == b) or (edge.x == b and edge.y == a):
			return
	edges.append(Vector2i(a, b))
	edge_health.append(thread_strength * new_thread_health_multiplier)
	edge_age.append(0.0)
	threads_label.text = "FÄDEN %d" % edges.size()


func _edge_exists(a: int, b: int) -> bool:
	return _edge_index(a, b) >= 0


func _edge_index(a: int, b: int) -> int:
	for i in range(edges.size()):
		var edge := edges[i]
		if (edge.x == a and edge.y == b) or (edge.x == b and edge.y == a):
			return i
	return -1


func _thread_cost(a: Vector2, b: Vector2) -> float:
	return clampf(10.0 + a.distance_to(b) / 30.0, 13.0, 38.0) * thread_cost_multiplier


func _add_architect_support(node: int, excluded: int) -> void:
	var nearest := -1
	var nearest_distance := 430.0
	for i in range(base_anchor_count):
		if i == node or i == excluded or _edge_exists(node, i):
			continue
		var distance := anchors[node].distance_to(anchors[i])
		if distance < nearest_distance:
			nearest = i
			nearest_distance = distance
	if nearest >= 0:
		_add_edge(node, nearest)


func _select_next_preview() -> void:
	if base_anchor_count <= 1:
		preview_anchor = -1
		return
	for attempt in range(base_anchor_count):
		preview_cursor = (preview_cursor + 1) % base_anchor_count
		if anchors[preview_cursor].distance_to(spider_position) < 150.0:
			continue
		preview_anchor = preview_cursor
		return
	preview_anchor = -1


func _spawn_insect() -> void:
	var roll := clampf(randf() + rare_spawn_bonus, 0.0, 0.999)
	var kind := "gnat"
	var value := 1
	var radius := randf_range(5.0, 7.0)
	var speed := randf_range(135.0, 185.0)
	var required_strength := 8.0
	var escape_time := 1.0
	var struggle_damage := 1.0
	var auto_collect := true
	if roll > 0.55 and roll <= 0.84:
		kind = "fly"
		value = 2
		radius = randf_range(9.0, 12.0)
		speed = randf_range(155.0, 205.0)
		required_strength = 16.0
		escape_time = 4.4
		struggle_damage = 6.0
		auto_collect = false
	elif roll > 0.84 and roll <= 0.97:
		kind = "moth"
		value = 4
		radius = randf_range(13.0, 17.0)
		speed = randf_range(115.0, 155.0)
		required_strength = 55.0
		escape_time = 2.8
		struggle_damage = 13.0
		auto_collect = false
	elif roll > 0.97:
		kind = "bee"
		value = 8
		radius = randf_range(15.0, 19.0)
		speed = randf_range(190.0, 245.0)
		required_strength = 108.0
		escape_time = 1.65
		struggle_damage = 30.0
		auto_collect = false
	var from_left := randf() < 0.5
	var y := randf_range(340.0, 1530.0)
	var direction := 1.0 if from_left else -1.0
	speed *= 1.0 + float(hunt_level - 1) * 0.07
	insects.append({
		"id": next_insect_id,
		"kind": kind,
		"position": Vector2(-35.0 if from_left else 1115.0, y),
		"velocity": Vector2(speed * direction, randf_range(-14.0, 14.0)),
		"radius": radius,
		"value": value,
		"caught": false,
		"edge": -1,
		"timer": 0.0,
		"phase": randf() * TAU,
		"required_strength": required_strength,
		"escape_time": escape_time,
		"struggle_damage": struggle_damage,
		"auto_collect": auto_collect,
		"boss": false,
		"boss_hits": 1,
		"ignored_edges": {}
	})
	next_insect_id += 1


func _spawn_boss_moth() -> void:
	if boss_active or level_complete:
		return
	boss_active = true
	var from_left := randf() < 0.5
	var direction := 1.0 if from_left else -1.0
	insects.append({
		"id": next_insect_id,
		"kind": "moth",
		"position": Vector2(-90.0 if from_left else 1170.0, randf_range(520.0, 1260.0)),
		"velocity": Vector2(118.0 * direction, randf_range(-22.0, 22.0)),
		"radius": 28.0,
		"value": 12,
		"caught": false,
		"edge": -1,
		"timer": 0.0,
		"phase": randf() * TAU,
		"required_strength": 72.0 + float(hunt_level - 1) * 8.0,
		"escape_time": 3.4,
		"struggle_damage": 21.0 + float(hunt_level - 1) * 2.0,
		"auto_collect": false,
		"boss": true,
		"boss_hits": 3 + floori(float(hunt_level - 1) * 0.5),
		"ignored_edges": {}
	})
	next_insect_id += 1
	status_label.text = "ABSCHLUSSMOTTE IM ANFLUG!"
	hint_label.text = "FANGE SIE MEHRFACH, BEVOR SIE DAS NETZ ZERREISST"


func _update_insects(delta: float) -> void:
	for i in range(insects.size() - 1, -1, -1):
		var insect := insects[i]
		if insect["caught"]:
			insect["timer"] += delta
			var edge_index: int = insect["edge"]
			if edge_index >= 0 and edge_index < edges.size():
				var edge := edges[edge_index]
				insect["position"] = anchors[edge.x].lerp(anchors[edge.y], insect["phase"])
				edge_health[edge_index] = maxf(0.0, edge_health[edge_index] - float(insect["struggle_damage"]) * struggle_damage_multiplier * delta)
			if insect["auto_collect"] and float(insect["timer"]) >= 0.42:
				status_label.text = "+1 XP - KLEINE MUECKE"
				_collect_insect(i)
			elif edge_index < 0 or edge_index >= edge_health.size() or edge_health[edge_index] <= 0.0:
				_escape_insect(i, "FADEN GERISSEN")
			elif float(insect["timer"]) >= float(insect["escape_time"]) * escape_time_multiplier:
				_escape_insect(i, "BEUTE ENTKOMMEN")
			continue

		var position: Vector2 = insect["position"]
		var velocity: Vector2 = insect["velocity"]
		position += velocity * prey_speed_multiplier * delta
		position.y += sin(elapsed_time * 4.0 + float(insect["phase"])) * 24.0 * delta
		insect["position"] = position

		var caught_edge := _find_capture_edge(position, float(insect["radius"]), insect["ignored_edges"])
		if caught_edge >= 0:
			var effective_requirement: float = float(insect["required_strength"]) * (0.76 if sticky_level > 0 else 1.0)
			if edge_health[caught_edge] + 0.01 >= effective_requirement:
				insect["caught"] = true
				insect["edge"] = caught_edge
				insect["timer"] = 0.0
				insect["phase"] = _segment_ratio(position, caught_edge)
				edge_health[caught_edge] = maxf(0.0, edge_health[caught_edge] - float(insect["radius"]) * 0.7)
				capture_flashes.append({"position": position, "life": 0.55})
				status_label.text = "ABSCHLUSSMOTTE FEST!" if insect["boss"] else "BEUTE FESTGEHALTEN - JETZT ANTIPPEN!"
				hint_label.text = "DER RING ZEIGT DIE VERBLEIBENDE FLUCHTZEIT"
			else:
				insect["ignored_edges"][caught_edge] = true
				edge_health[caught_edge] = maxf(0.0, edge_health[caught_edge] - effective_requirement * 0.42)
				insect["velocity"].y += randf_range(-85.0, 85.0)
				status_label.text = "ZU SCHWACH - BEUTE BRICHT DURCH"
		elif position.x < -90.0 or position.x > 1170.0 or position.y < 180.0 or position.y > 1700.0:
			if insect["boss"]:
				var from_left := randf() < 0.5
				var direction := 1.0 if from_left else -1.0
				insect["position"] = Vector2(-90.0 if from_left else 1170.0, randf_range(480.0, 1320.0))
				insect["velocity"] = Vector2(125.0 * direction, randf_range(-28.0, 28.0))
				insect["ignored_edges"] = {}
				status_label.text = "DIE ABSCHLUSSMOTTE DREHT NOCH EINE RUNDE"
			else:
				insects.remove_at(i)


func _find_capture_edge(position: Vector2, insect_radius: float, ignored_edges: Dictionary) -> int:
	for i in range(edges.size()):
		if edge_health[i] <= 0.0:
			continue
		if ignored_edges.has(i):
			continue
		var edge := edges[i]
		if _distance_to_segment(position, anchors[edge.x], anchors[edge.y]) <= capture_radius + insect_radius:
			return i
	return -1


func _caught_insect_at(tap_position: Vector2) -> int:
	var nearest := -1
	var nearest_distance := pounce_radius
	for i in range(insects.size()):
		if not insects[i]["caught"] or insects[i]["auto_collect"]:
			continue
		var distance := tap_position.distance_to(insects[i]["position"])
		if distance < nearest_distance:
			nearest = i
			nearest_distance = distance
	return nearest


func _pounce_on_insect(index: int) -> void:
	if is_jumping or index < 0 or index >= insects.size():
		return
	var insect_id: int = insects[index]["id"]
	pounce_target_id = insect_id
	is_jumping = true
	travel_from = -1
	travel_to = -1
	jump_start = spider_position
	jump_target = insects[index]["position"]
	jump_progress = 0.0
	spider_rotation = (jump_target - jump_start).angle() - PI * 0.5
	status_label.text = "SPRUNG ZUR BEUTE"
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(_set_jump_progress, 0.0, 1.0, POUNCE_DURATION * jump_duration_multiplier * pounce_duration_multiplier)
	await tween.finished
	spider_position = jump_target
	is_jumping = false
	jump_progress = 0.0
	spider_visual_offset = Vector2.ZERO
	spider_visual_scale = Vector2(1.12, 0.84)
	landing_timer = 0.22
	var prey_index := _insect_index_by_id(insect_id)
	if prey_index >= 0 and insects[prey_index]["caught"]:
		var captured_edge: int = insects[prey_index]["edge"]
		var captured_phase: float = insects[prey_index]["phase"]
		var is_boss: bool = insects[prey_index]["boss"]
		if is_boss and int(insects[prey_index]["boss_hits"]) > boss_damage:
			insects[prey_index]["boss_hits"] = int(insects[prey_index]["boss_hits"]) - boss_damage
			_escape_insect(prey_index, "TREFFER! NOCH %d" % int(insects[prey_index]["boss_hits"]))
		else:
			_collect_insect(prey_index)
			status_label.text = "ABSCHLUSSMOTTE BEZWUNGEN" if is_boss else "BEUTE EINGEWICKELT"
		if captured_edge >= 0 and captured_edge < edges.size() and edge_health[captured_edge] > 0.0:
			if pounce_repair_amount > 0.0:
				edge_health[captured_edge] = minf(thread_strength * new_thread_health_multiplier, edge_health[captured_edge] + pounce_repair_amount)
			var edge := edges[captured_edge]
			travel_from = edge.x
			travel_to = edge.y
			travel_progress = captured_phase
			current_node = edge.x
			previous_node = -1
		else:
			current_node = _nearest_anchor(spider_position)
			spider_position = anchors[current_node]
			previous_node = -1
			_start_auto_travel()
	else:
		status_label.text = "ZU SPAET - BEUTE IST WEG"
		current_node = _nearest_anchor(spider_position)
		spider_position = anchors[current_node]
		previous_node = -1
		_start_auto_travel()
	pounce_target_id = -1


func _insect_index_by_id(insect_id: int) -> int:
	for i in range(insects.size()):
		if int(insects[i]["id"]) == insect_id:
			return i
	return -1


func _nearest_anchor(position: Vector2) -> int:
	var nearest := 0
	var nearest_distance := INF
	for i in range(anchors.size()):
		var distance := position.distance_squared_to(anchors[i])
		if distance < nearest_distance:
			nearest = i
			nearest_distance = distance
	return nearest


func _escape_insect(index: int, message: String) -> void:
	if index < 0 or index >= insects.size():
		return
	var insect := insects[index]
	var old_edge: int = insect["edge"]
	if old_edge >= 0:
		insect["ignored_edges"][old_edge] = true
	insect["caught"] = false
	insect["edge"] = -1
	insect["timer"] = 0.0
	var velocity: Vector2 = insect["velocity"]
	velocity *= 1.28
	velocity.y += randf_range(-120.0, 120.0)
	insect["velocity"] = velocity
	status_label.text = message


func _distance_to_segment(point: Vector2, a: Vector2, b: Vector2) -> float:
	var segment := b - a
	var length_squared := segment.length_squared()
	if length_squared <= 0.001:
		return point.distance_to(a)
	var ratio := clampf((point - a).dot(segment) / length_squared, 0.0, 1.0)
	return point.distance_to(a + segment * ratio)


func _segment_ratio(point: Vector2, edge_index: int) -> float:
	var edge := edges[edge_index]
	var a := anchors[edge.x]
	var segment := anchors[edge.y] - a
	if segment.length_squared() <= 0.001:
		return 0.5
	return clampf((point - a).dot(segment) / segment.length_squared(), 0.0, 1.0)


func _collect_insect(index: int, allow_chain: bool = true) -> void:
	var insect := insects[index]
	var value: int = insect["value"]
	var was_auto: bool = insect["auto_collect"]
	var was_boss: bool = insect["boss"]
	var reward_multiplier := food_multiplier
	var xp_multiplier := 1.0
	var local_silk_multiplier := silk_gain_multiplier
	if was_auto and gnat_reward_level > 0:
		reward_multiplier *= 1.0 + float(gnat_reward_level)
		local_silk_multiplier *= 1.0 + 0.5 * float(gnat_reward_level)
	elif not was_auto:
		reward_multiplier *= active_catch_multiplier
		xp_multiplier *= active_catch_multiplier
	if was_boss:
		reward_multiplier *= boss_reward_multiplier
		xp_multiplier *= boss_reward_multiplier
		local_silk_multiplier *= boss_reward_multiplier
	var reward := maxi(1, roundi(float(value) * reward_multiplier))
	if not insect["auto_collect"] and randf() < double_food_chance:
		reward *= 2
		status_label.text = "KRITISCHER FANG - DOPPELTE NAHRUNG!"
	food += reward
	hunt_food += reward
	xp += maxi(1, roundi(float(value) * xp_multiplier))
	var silk_gain := (4.0 + float(value) * 2.0) * local_silk_multiplier
	silk = minf(silk_max, silk + silk_gain)
	insects.remove_at(index)
	if recycler_level > 0:
		_repair_weakest_thread(8.0 + float(recycler_level) * 4.0)
	if was_boss:
		_complete_hunt_level()
		return
	if allow_chain and not was_auto and chain_capture_chance > 0.0 and randf() < chain_capture_chance:
		for chained_index in range(insects.size()):
			if insects[chained_index]["caught"] and not insects[chained_index]["auto_collect"] and not insects[chained_index]["boss"]:
				_collect_insect(chained_index, false)
				status_label.text = "KETTENFANG - ZWEITE BEUTE EINGEWICKELT!"
				break
	if hunt_food >= hunt_goal and not boss_active:
		_spawn_boss_moth()
	if xp >= xp_target and not level_complete:
		_open_upgrade()


func _repair_weakest_thread(amount: float) -> void:
	var weakest := -1
	var weakest_health := INF
	for i in range(edge_health.size()):
		if edge_health[i] > 0.0 and edge_health[i] < weakest_health:
			weakest = i
			weakest_health = edge_health[i]
	if weakest >= 0:
		edge_health[weakest] = minf(thread_strength, edge_health[weakest] + amount)


func _complete_hunt_level() -> void:
	level_complete = true
	boss_active = false
	insects.clear()
	level_complete_overlay.visible = true
	level_complete_title.text = "LEVEL %d GESCHAFFT" % hunt_level
	level_complete_detail.text = "%d Nahrung gesammelt\nAbschlussmotte gefangen\n\nTIPPE FÜR LEVEL %d" % [hunt_food, hunt_level + 1]
	status_label.text = "JAGDAUFTRAG ERFÜLLT"
	hint_label.text = "TIPPE, UM WEITERZUSPIELEN"


func _start_next_hunt_level() -> void:
	hunt_level += 1
	hunt_food = 0
	hunt_goal = roundi(24.0 * pow(1.32, hunt_level - 1))
	boss_active = false
	emergency_reserve_used = false
	level_complete = false
	level_complete_overlay.visible = false
	insect_timer = 0.0
	status_label.text = "LEVEL %d - NEUER JAGDAUFTRAG" % hunt_level
	hint_label.text = "SAMMLE NAHRUNG UND LOCKE DIE ABSCHLUSSMOTTE AN"
	_update_hud()
	if xp >= xp_target:
		_open_upgrade()


func _update_threads(delta: float) -> void:
	emergency_patch_cooldown = maxf(0.0, emergency_patch_cooldown - delta)
	var total_ratio := 0.0
	var active_count := 0
	for i in range(edges.size()):
		edge_age[i] += delta
		if edge_health[i] <= 0.0:
			if emergency_patch_level > 0 and emergency_patch_cooldown <= 0.0:
				edge_health[i] = thread_strength * 0.45
				edge_age[i] = 0.0
				emergency_patch_cooldown = maxf(5.0, 14.0 - 3.0 * float(emergency_patch_level))
				status_label.text = "NOTFALLFLICKEN - FADEN GERETTET!"
			else:
				continue
		if edge_age[i] > THREAD_GRACE_TIME:
			edge_health[i] = maxf(0.0, edge_health[i] - delta * THREAD_DECAY_PER_SECOND * thread_decay_multiplier)
		total_ratio += edge_health[i] / maxf(thread_strength, 1.0)
		active_count += 1

	if edges.is_empty():
		integrity = 100.0
	else:
		integrity = clampf((total_ratio / float(edges.size())) * 100.0, 0.0, 100.0)

	if active_count == 0 and not edges.is_empty() and silk < 13.0:
		_end_run()


func _try_emergency_reserve() -> void:
	if emergency_reserve_level <= 0 or emergency_reserve_used:
		return
	if silk <= silk_max * 0.15:
		emergency_reserve_used = true
		silk = minf(silk_max, silk + 25.0 + 10.0 * float(emergency_reserve_level))
		status_label.text = "NOTRESERVE GEÖFFNET - SEIDE AUFGEFÜLLT!"


func _apply_wind_gust() -> void:
	var candidates: Array[int] = []
	for i in range(edge_health.size()):
		if edge_health[i] > 0.0:
			candidates.append(i)
	if candidates.is_empty():
		return
	var chosen := candidates[randi() % candidates.size()]
	edge_health[chosen] = maxf(0.0, edge_health[chosen] - 18.0 * wind_damage_multiplier)
	status_label.text = "WINDSTOSS – EIN FADEN WIRD SCHWÄCHER"


func _open_upgrade() -> void:
	if upgrade_open:
		return
	offered_upgrades = _roll_upgrade_offer()
	if offered_upgrades.size() < 3:
		return
	upgrade_open = true
	upgrade_selecting = false
	upgrade_overlay.visible = true
	upgrade_level_caption.text = "LEVEL %d" % (level + 1)
	status_label.text = "LEVEL %d" % (level + 1)
	var cards: Array[Button] = [upgrade_one, upgrade_two, upgrade_three]
	for i in range(cards.size()):
		var card := cards[i]
		_configure_upgrade_card(card, offered_upgrades[i])
		card.disabled = false
		card.scale = Vector2(0.82, 0.82)
		card.modulate = Color(1.0, 1.0, 1.0, 0.0)
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(card, "scale", Vector2.ONE, 0.28).set_delay(float(i) * 0.07).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(card, "modulate", Color.WHITE, 0.18).set_delay(float(i) * 0.07)


func _roll_upgrade_offer() -> Array[Dictionary]:
	var candidates: Array[Dictionary] = []
	for upgrade in UpgradeDB.all():
		var current_level := int(upgrade_levels.get(upgrade["id"], 0))
		if current_level >= int(upgrade["max_level"]):
			continue
		var requirements_met := true
		var requirements: Dictionary = upgrade["requires"]
		for requirement_id in requirements:
			if int(upgrade_levels.get(requirement_id, 0)) < int(requirements[requirement_id]):
				requirements_met = false
				break
		if requirements_met:
			candidates.append(upgrade)

	var result: Array[Dictionary] = []
	while result.size() < 3 and not candidates.is_empty():
		var total_weight := 0.0
		for candidate in candidates:
			total_weight += float(candidate["weight"])
		var roll := randf() * total_weight
		var selected_index := 0
		for i in range(candidates.size()):
			roll -= float(candidates[i]["weight"])
			if roll <= 0.0:
				selected_index = i
				break
		result.append(candidates[selected_index])
		candidates.remove_at(selected_index)
	return result


func _configure_upgrade_card(card: Button, upgrade: Dictionary) -> void:
	var current_level := int(upgrade_levels.get(upgrade["id"], 0))
	var rarity_names := {"common": "GEWÖHNLICH", "uncommon": "UNGEWÖHNLICH", "rare": "SELTEN"}
	var rarity_label := card.get_node("Rarity") as Label
	var title_label := card.get_node("Title") as Label
	var value_label := card.get_node("Value") as Label
	var description_label := card.get_node("Description") as Label
	var ribbon_label := card.get_node("Ribbon/Label") as Label
	rarity_label.text = "%s  ·  STUFE %d/%d" % [rarity_names[upgrade["rarity"]], current_level + 1, int(upgrade["max_level"])]
	rarity_label.add_theme_font_size_override("font_size", 17)
	title_label.text = upgrade["title"]
	title_label.add_theme_font_size_override("font_size", 24 if String(upgrade["title"]).length() > 15 else 28)
	value_label.text = upgrade["value"]
	value_label.add_theme_font_size_override("font_size", 21 if String(upgrade["value"]).length() > 20 else 26)
	description_label.text = upgrade["description"]
	description_label.add_theme_font_size_override("font_size", 19)
	ribbon_label.text = upgrade["build"]
	var icon_key: String = upgrade["icon"]
	var icon: Texture2D = UPGRADE_ICON_TEXTURES.get(icon_key) as Texture2D
	var icon_rect := card.get_node("Icon") as TextureRect
	icon_rect.texture = icon


func _choose_upgrade(choice: int) -> void:
	if not upgrade_open or upgrade_selecting:
		return
	upgrade_selecting = true
	var cards: Array[Button] = [upgrade_one, upgrade_two, upgrade_three]
	for card in cards:
		card.disabled = true
	var chosen := cards[choice]
	var select_tween := create_tween()
	select_tween.set_parallel(true)
	select_tween.tween_property(chosen, "scale", Vector2(1.08, 1.08), 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	for i in range(cards.size()):
		if i != choice:
			select_tween.tween_property(cards[i], "modulate", Color(1.0, 1.0, 1.0, 0.2), 0.14)
	await select_tween.finished
	var upgrade := offered_upgrades[choice]
	var upgrade_id: String = upgrade["id"]
	upgrade_levels[upgrade_id] = int(upgrade_levels.get(upgrade_id, 0)) + 1
	_apply_upgrade_effect(upgrade_id)
	status_label.text = "%s · STUFE %d" % [upgrade["title"], int(upgrade_levels[upgrade_id])]

	xp -= xp_target
	level += 1
	xp_target = roundi(24.0 * pow(1.35, level - 1))
	upgrade_open = false
	upgrade_overlay.visible = false
	upgrade_selecting = false
	_update_hud()


func _apply_upgrade_effect(upgrade_id: String) -> void:
	match upgrade_id:
		"strong_silk":
			thread_strength += 20.0
			strong_silk_level += 1
			for i in range(edge_health.size()):
				edge_health[i] = minf(thread_strength, edge_health[i] + 45.0)
		"elastic_threads":
			thread_decay_multiplier *= 0.78
		"reinforced_knots":
			wind_damage_multiplier *= 0.65
		"fortress_core":
			thread_strength += 35.0
			struggle_damage_multiplier *= 0.7
			for i in range(edge_health.size()):
				edge_health[i] = thread_strength
		"sticky_web":
			capture_radius *= 1.18
			escape_time_multiplier *= 1.1
			sticky_level += 1
		"deep_glue":
			escape_time_multiplier *= 1.18
			prey_speed_multiplier *= 0.9
		"vibration_sense":
			rare_spawn_bonus += 0.08
		"perfect_ambush":
			escape_time_multiplier *= 1.4
			capture_radius *= 1.12
		"quick_legs":
			spider_speed *= 1.16
			jump_duration_multiplier *= 0.88
			speed_level += 1
		"hunting_instinct":
			pounce_radius += 30.0
			pounce_duration_multiplier *= 0.9
		"critical_capture":
			double_food_chance += 0.18
		"venom_bite":
			boss_damage += 1
		"silk_glands":
			silk_max += 20.0
			silk = silk_max
		"fine_spinning":
			thread_cost_multiplier *= 0.82
		"recycler":
			silk_gain_multiplier *= 1.3
			recycler_level += 1
		"architect":
			architect_level = 1
		"armored_knots":
			new_thread_health_multiplier += 0.35
		"emergency_patch":
			emergency_patch_level += 1
			emergency_patch_cooldown = 0.0
		"dew_trap":
			gnat_reward_level += 1
		"chain_capture":
			chain_capture_chance += 0.2
		"predator_focus":
			active_catch_multiplier += 0.25
		"silk_dash":
			pounce_duration_multiplier *= 0.78
			pounce_repair_amount += 12.0
		"emergency_reserve":
			emergency_reserve_level += 1
			emergency_reserve_used = false
		"rich_cocoon":
			boss_reward_multiplier += 0.5


func _end_run() -> void:
	game_over = true
	travel_from = -1
	travel_to = -1
	status_label.text = "DAS NETZ IST KOLLABIERT"
	hint_label.text = "TIPPE, UM EIN NEUES NETZ ZU BEGINNEN"


func _update_hud() -> void:
	integrity_label.text = "NETZ-INTEGRITÄT %d %%" % roundi(integrity)
	var active_threads := 0
	for health in edge_health:
		if health > 0.0:
			active_threads += 1
	threads_label.text = "FÄDEN %d" % active_threads
	food_label.text = "NAHRUNG %d" % food
	level_label.text = "BUILD-LVL %d" % level
	silk_label.text = "SEIDE  %d/%d" % [roundi(silk), roundi(silk_max)]
	xp_label.text = "XP  %d/%d" % [xp, xp_target]
	silk_bar.max_value = silk_max
	silk_bar.value = silk
	xp_bar.max_value = xp_target
	xp_bar.value = xp
	if boss_active:
		hunt_goal_label.text = "LEVEL %d · ABSCHLUSSMOTTE" % hunt_level
	else:
		hunt_goal_label.text = "JAGDZIEL L%d  ·  NAHRUNG %d/%d" % [hunt_level, hunt_food, hunt_goal]
	build_label.text = _build_summary_text()


func _build_summary_text() -> String:
	if upgrade_levels.is_empty():
		return "BUILD: NOCH OFFEN"
	var counts := {"FESTUNG": 0, "FALLE": 0, "JÄGERIN": 0, "ÖKONOMIE": 0}
	for upgrade in UpgradeDB.all():
		var upgrade_level := int(upgrade_levels.get(upgrade["id"], 0))
		if upgrade_level > 0:
			counts[upgrade["build"]] = int(counts[upgrade["build"]]) + upgrade_level
	var best_build := ""
	var best_count := 0
	var second_build := ""
	var second_count := 0
	for build_name in counts:
		var count: int = counts[build_name]
		if count > best_count:
			second_build = best_build
			second_count = best_count
			best_build = build_name
			best_count = count
		elif count > second_count:
			second_build = build_name
			second_count = count
	if second_count > 0:
		return "BUILD: %s %d  ·  %s %d" % [best_build, best_count, second_build, second_count]
	return "BUILD: %s %d" % [best_build, best_count]


func _draw() -> void:
	_draw_background()
	_draw_ambience()
	if menu_open:
		return
	_draw_anchors()
	_draw_web()
	_draw_insects()
	_draw_capture_flashes()
	_draw_preview()
	if not upgrade_open:
		_draw_spider(spider_position)


func _draw_background() -> void:
	var source_size := BACKGROUND_TEXTURE.get_size()
	var target_ratio := DESIGN_SIZE.x / DESIGN_SIZE.y
	var crop_width := source_size.y * target_ratio
	var source_rect := Rect2(Vector2((source_size.x - crop_width) * 0.5, 0.0), Vector2(crop_width, source_size.y))
	draw_texture_rect_region(BACKGROUND_TEXTURE, Rect2(Vector2.ZERO, DESIGN_SIZE), source_rect)
	draw_rect(Rect2(Vector2.ZERO, DESIGN_SIZE), Color(DARK_MOSS, 0.12))


func _draw_anchors() -> void:
	for i in range(base_anchor_count):
		var color := Color(HONEY, 0.18)
		if i == preview_anchor:
			color = Color(SKY, 0.35)
		draw_circle(anchors[i], 12.0, color)
		draw_circle(anchors[i], 4.0, Color(HONEY, 0.7))


func _draw_web() -> void:
	for i in range(edges.size()):
		var edge := edges[i]
		var health_ratio := clampf(edge_health[i] / maxf(thread_strength, 1.0), 0.0, 1.0)
		if health_ratio <= 0.0:
			continue
		var a := anchors[edge.x]
		var b := anchors[edge.y]
		draw_line(a, b, Color(CREAM, 0.12 * health_ratio), 9.0, true)
		var core_color := Color(HONEY, 0.48 + 0.42 * health_ratio) if strong_silk_level > 0 else Color(CREAM, 0.42 + 0.45 * health_ratio)
		if sticky_level > 0:
			draw_line(a, b, Color(SKY, 0.13 + 0.04 * minf(sticky_level, 3)), 7.0 + health_ratio, true)
		draw_line(a, b, core_color, 2.5 + health_ratio + float(strong_silk_level) * 0.35, true)
		draw_circle(a, 6.0, Color(HONEY, 0.8))
		draw_circle(b, 6.0, Color(HONEY, 0.8))


func _draw_insects() -> void:
	for insect in insects:
		var position: Vector2 = insect["position"]
		var velocity: Vector2 = insect["velocity"]
		var rotation := velocity.angle() + PI * 0.5
		var kind: String = insect["kind"]
		var texture := FLY_TEXTURE
		var scale := 0.045
		if kind == "gnat":
			scale = 0.025
		elif kind == "moth":
			texture = MOTH_TEXTURE
			scale = 0.066
		elif kind == "bee":
			texture = BEE_TEXTURE
			scale = 0.062
		if insect["boss"]:
			scale = 0.125
			var boss_pulse := 1.0 + sin(elapsed_time * 5.0) * 0.06
			draw_circle(position, 92.0 * boss_pulse, Color(BERRY, 0.18))
			draw_arc(position, 94.0 * boss_pulse, 0.0, TAU, 48, Color(HONEY, 0.82), 6.0, true)
			var hit_count: int = insect["boss_hits"]
			for hit in range(hit_count):
				draw_circle(position + Vector2((float(hit) - float(hit_count - 1) * 0.5) * 22.0, -108.0), 7.0, ORANGE)
		if insect["caught"] and not insect["auto_collect"]:
			scale *= 0.9
			var remaining := clampf(1.0 - float(insect["timer"]) / float(insect["escape_time"]), 0.0, 1.0)
			var ring_color := Color(HONEY, 0.96) if remaining > 0.38 else Color(ORANGE, 1.0)
			var ring_radius := 88.0 if insect["boss"] else 59.0
			draw_circle(position, ring_radius - 1.0, Color(DARK_MOSS, 0.34))
			draw_arc(position, ring_radius, -PI * 0.5, -PI * 0.5 + TAU * remaining, 48, ring_color, 8.0, true)
		_draw_texture_centered(texture, position, scale, rotation, Color.WHITE if not insect["caught"] else Color(1.0, 0.78, 0.62, 1.0))
		if insect["caught"] and not insect["auto_collect"]:
			draw_arc(position, 72.0 + sin(elapsed_time * 10.0) * 4.0, 0.0, TAU, 32, Color(CREAM, 0.5), 3.0, true)


func _create_pollen() -> void:
	for i in range(34):
		pollen_particles.append({
			"position": Vector2(randf_range(20.0, 1060.0), randf_range(250.0, 1880.0)),
			"speed": randf_range(7.0, 18.0),
			"phase": randf() * TAU,
			"size": randf_range(1.5, 4.0)
		})


func _update_ambience(delta: float) -> void:
	for particle in pollen_particles:
		var position: Vector2 = particle["position"]
		position.y -= float(particle["speed"]) * delta
		position.x += sin(elapsed_time * 0.7 + float(particle["phase"])) * 8.0 * delta
		if position.y < 235.0:
			position.y = 1890.0
			position.x = randf_range(20.0, 1060.0)
		particle["position"] = position
	for i in range(capture_flashes.size() - 1, -1, -1):
		capture_flashes[i]["life"] = float(capture_flashes[i]["life"]) - delta
		if float(capture_flashes[i]["life"]) <= 0.0:
			capture_flashes.remove_at(i)


func _draw_ambience() -> void:
	for particle in pollen_particles:
		draw_circle(particle["position"], particle["size"], Color(HONEY, 0.24))


func _draw_capture_flashes() -> void:
	for flash in capture_flashes:
		var life: float = flash["life"]
		var progress := 1.0 - life / 0.55
		draw_arc(flash["position"], 14.0 + progress * 34.0, 0.0, TAU, 32, Color(HONEY, life), 4.0, true)


func _draw_preview() -> void:
	if preview_anchor < 0 or game_over:
		return
	var target := anchors[preview_anchor]
	draw_dashed_line(spider_position, target, Color(SKY, 0.34), 3.0, 18.0, true)
	draw_circle(target, 27.0, Color(SKY, 0.11))
	draw_arc(target, 27.0, 0.0, TAU, 32, SKY, 4.0, true)
	draw_circle(target, 6.0, HONEY)


func _draw_spider(position: Vector2) -> void:
	var bob := 0.0 if is_jumping else sin(spider_anim_time * TAU) * 2.5
	var p := position + spider_visual_offset + Vector2(0.0, bob)
	var altitude_ratio := -spider_visual_offset.y / 78.0
	var shadow_scale := 1.0 - altitude_ratio * 0.42
	draw_set_transform(position + Vector2(0.0, 17.0), 0.0, Vector2(shadow_scale, shadow_scale * 0.42))
	draw_circle(Vector2.ZERO, 58.0, Color(DARK_MOSS, 0.19 - altitude_ratio * 0.08))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	var texture := SPIDER_JUMP_TEXTURE if is_jumping else SPIDER_CRAWL_TEXTURE
	_draw_spider_sheet_frame(texture, spider_anim_frame, p, 0.27, spider_rotation, spider_visual_scale)


func _draw_spider_sheet_frame(texture: Texture2D, frame: int, position: Vector2, scale: float, rotation: float, stretch: Vector2) -> void:
	var cell := texture.get_size() * 0.5
	var column := frame % 2
	var row := frame / 2
	var source := Rect2(Vector2(column * cell.x, row * cell.y), cell)
	var target := Rect2(-cell * 0.5, cell)
	draw_set_transform(position, rotation, Vector2(scale * stretch.x, scale * stretch.y))
	draw_texture_rect_region(texture, target, source)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_texture_centered(texture: Texture2D, position: Vector2, scale: float, rotation: float, modulate: Color = Color.WHITE) -> void:
	draw_set_transform(position, rotation, Vector2(scale, scale))
	draw_texture(texture, -texture.get_size() * 0.5, modulate)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
