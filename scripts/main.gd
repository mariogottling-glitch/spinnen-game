extends Node2D

const DESIGN_SIZE := Vector2(1080.0, 1920.0)
const ANDROID_UPDATE_URL := "https://github.com/mariogottling-glitch/spinnen-game/releases/latest/download/web-weaver-android.apk?download=1"
const FOREST := Color("#2F6B45")
const DARK_MOSS := Color("#214233")
const LEAF := Color("#6DAE5B")
const CREAM := Color("#F8F5EB")
const HONEY := Color("#F4C556")
const ORANGE := Color("#E86B45")
const SKY := Color("#7DC7E8")
const BERRY := Color("#9B6AA6")

const BACKGROUND_TEXTURE: Texture2D = preload("res://assets/backgrounds/forest-fadenschnitt-v1.png")
const SPIDER_TEXTURE: Texture2D = preload("res://assets/sprites/spider-fadenschnitt-v1.png")
const SPIDER_CRAWL_TEXTURE: Texture2D = preload("res://assets/sprites/spider-crawl-fadenschnitt-v1.png")
const SPIDER_JUMP_TEXTURE: Texture2D = preload("res://assets/sprites/spider-jump-fadenschnitt-v1.png")
const MOTH_TEXTURE: Texture2D = preload("res://assets/sprites/moth-fadenschnitt-v1.png")
const FLY_TEXTURE: Texture2D = preload("res://assets/sprites/fly-fadenschnitt-v1.png")
const BEE_TEXTURE: Texture2D = preload("res://assets/sprites/bee-fadenschnitt-v1.png")
const WASP_TEXTURE: Texture2D = preload("res://assets/sprites/wasp-fadenschnitt-v1.png")
const BEETLE_TEXTURE: Texture2D = preload("res://assets/ui/contracts/beetle-fadenschnitt-v1.png")
const DRAGONFLY_TEXTURE: Texture2D = preload("res://assets/ui/contracts/dragonfly-fadenschnitt-v1.png")
const FIREFLY_TEXTURE: Texture2D = preload("res://assets/ui/contracts/firefly-fadenschnitt-v1.png")
const WASP_QUEEN_TEXTURE: Texture2D = preload("res://assets/sprites/boss-wasp-queen-fadenschnitt-v1.png")
const TITAN_BEETLE_TEXTURE: Texture2D = preload("res://assets/sprites/boss-titan-beetle-fadenschnitt-v1.png")
const RAZOR_HORNET_TEXTURE: Texture2D = preload("res://assets/sprites/boss-razor-hornet-fadenschnitt-v1.png")
const FADENSCHNITT_DISPLAY_FONT: Font = preload("res://assets/fonts/BarlowCondensed-SemiBold.ttf")
const THREAD_NATURAL_TEXTURE: Texture2D = preload("res://assets/web/thread-natural-v1.png")
const THREAD_REINFORCED_TEXTURE: Texture2D = preload("res://assets/web/thread-reinforced-v1.png")
const THREAD_STICKY_TEXTURE: Texture2D = preload("res://assets/web/thread-sticky-v1.png")
const THREAD_KNOT_TEXTURE: Texture2D = preload("res://assets/web/thread-knot-v1.png")
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
	"rich_cocoon": preload("res://assets/ui/perks/rich-cocoon.png"),
	"brood_nest": preload("res://assets/ui/perks/brood-nest.png"),
	"silk_menders": preload("res://assets/ui/perks/silk-menders.png"),
	"young_hunters": preload("res://assets/ui/perks/young-hunters.png"),
	"swarm_instinct": preload("res://assets/ui/perks/swarm-instinct.png"),
	"spider_queen": preload("res://assets/ui/perks/spider-queen.png")
}
const UpgradeDB = preload("res://scripts/upgrade_database.gd")
const FadenschnittTheme = preload("res://scripts/fadenschnitt_theme.gd")
const HUNT_CONTRACTS: Array[Dictionary] = [
	{
		"id": "glass_hunt", "title": "GLÄSERNE JAGD", "sigil": "◆",
		"risk": "Fäden erleiden +35 % Schaden", "reward": "+50 % Nahrung · +10 % XP",
		"special": "KÄFER", "preferred": "beetle", "spawn": 0.95, "damage": 1.35,
		"food": 1.5, "xp": 1.1, "silk": 1.0, "special_chance": 0.22, "rare": 0.03,
		"escape": 1.0, "speed": 1.0, "goal": 1.0, "vibration_floor": 0.0
	},
	{
		"id": "storm_lane", "title": "STURMKORRIDOR", "sigil": "✦",
		"risk": "Anflüge sind 18 % schneller", "reward": "+45 % XP",
		"special": "LIBELLE", "preferred": "dragonfly", "spawn": 0.72, "damage": 1.1,
		"food": 1.12, "xp": 1.45, "silk": 1.0, "special_chance": 0.25, "rare": 0.02,
		"escape": 1.0, "speed": 1.18, "goal": 1.0, "vibration_floor": 0.0
	},
	{
		"id": "night_glow", "title": "NACHTLEUCHTEN", "sigil": "●",
		"risk": "Beute entkommt 18 % früher", "reward": "+45 % Seide · +15 % Nahrung",
		"special": "GLÜHWÜRMCHEN", "preferred": "firefly", "spawn": 0.9, "damage": 1.0,
		"food": 1.15, "xp": 1.0, "silk": 1.45, "special_chance": 0.27, "rare": 0.01,
		"escape": 0.82, "speed": 1.0, "goal": 1.0, "vibration_floor": 0.0
	},
	{
		"id": "silk_famine", "title": "SEIDENHUNGER", "sigil": "◇",
		"risk": "Neue Fäden kosten 25 % mehr", "reward": "+65 % Nahrung",
		"special": "KÄFER", "preferred": "beetle", "spawn": 0.88, "damage": 1.05,
		"food": 1.65, "xp": 1.0, "silk": 1.0, "special_chance": 0.18, "rare": 0.04,
		"escape": 1.0, "speed": 1.0, "goal": 1.0, "vibration_floor": 0.0, "thread_cost": 1.25
	},
	{
		"id": "echo_web", "title": "ECHO-NETZ", "sigil": "≈",
		"risk": "Vibration bleibt mindestens bei 30 %", "reward": "+35 % Nahrung · +25 % XP",
		"special": "LIBELLE", "preferred": "dragonfly", "spawn": 0.8, "damage": 1.18,
		"food": 1.35, "xp": 1.25, "silk": 1.0, "special_chance": 0.2, "rare": 0.04,
		"escape": 1.0, "speed": 1.08, "goal": 1.0, "vibration_floor": 30.0
	},
	{
		"id": "golden_calm", "title": "GOLDENE RUHE", "sigil": "✺",
		"risk": "Das Jagdziel ist 30 % höher", "reward": "Weniger Netzschaden · seltene Beute",
		"special": "GLÜHWÜRMCHEN", "preferred": "firefly", "spawn": 1.05, "damage": 0.82,
		"food": 1.25, "xp": 1.15, "silk": 1.25, "special_chance": 0.24, "rare": 0.07,
		"escape": 1.1, "speed": 0.95, "goal": 1.3, "vibration_floor": 0.0
	}
]

const PLAY_RECT := Rect2(70.0, 230.0, 940.0, 1390.0)
const JUMP_DURATION := 0.46
const PREVIEW_INTERVAL := 0.82
const INSECT_SPAWN_INTERVAL := 1.65
const WIND_INTERVAL := 8.0
const POUNCE_DURATION := 0.28
const BITE_SWEEP_DURATION := 1.45
const BITE_PERFECT_WINDOW := 0.16
const BITE_GOOD_PADDING := 0.13
const THREAD_GRACE_TIME := 24.0
const THREAD_DECAY_PER_SECOND := 1.0
const LURE_COOLDOWN := 8.0
const GLYPH_REFRESH_INTERVAL := 0.45

var anchors: Array[Vector2] = []
var base_anchor_count := 0
var edges: Array[Vector2i] = []
var edge_health: Array[float] = []
var edge_age: Array[float] = []
var insects: Array[Dictionary] = []
var pollen_particles: Array[Dictionary] = []
var capture_flashes: Array[Dictionary] = []
var helper_spiders: Array[Dictionary] = []
var flight_warnings: Array[Dictionary] = []
var web_glyphs: Array[Dictionary] = []
var web_glyph_ids: Dictionary = {}

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
var upgrade_rerolls_remaining := 1
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
var brood_nest_level := 0
var silk_menders_level := 0
var young_hunters_level := 0
var swarm_instinct_level := 0
var spider_queen_level := 0
var helper_action_timer := 0.0
var bite_active := false
var bite_target_id := -1
var bite_progress := 0.0
var bite_target_center := 0.62
var vibration := 0.0
var lure_cooldown := 0.0
var glyph_refresh_timer := 0.0
var glyph_effect_timer := 0.0
var glyph_combo := 0
var glyph_combo_timer := 0.0
var contract_open := false
var offered_contracts: Array[Dictionary] = []
var current_contract: Dictionary = {}
var contract_spawn_multiplier := 1.0
var contract_damage_multiplier := 1.0
var contract_food_multiplier := 1.0
var contract_xp_multiplier := 1.0
var contract_silk_multiplier := 1.0
var contract_escape_multiplier := 1.0
var contract_speed_multiplier := 1.0
var contract_special_chance := 0.06
var contract_preferred_special := ""
var contract_vibration_floor := 0.0
var contract_thread_cost_multiplier := 1.0
var contract_rare_bonus := 0.0

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
var run_complete := false
var tutorial_step := 0
var menu_open := true
var run_started := false
var reduced_motion := false
var menu_transitioning := false
var reset_confirmation_pending := false

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
@onready var upgrade_build_hint: Label = $HUD/UpgradeOverlay/BuildHint
@onready var upgrade_one: Button = $HUD/UpgradeOverlay/UpgradeOne
@onready var upgrade_two: Button = $HUD/UpgradeOverlay/UpgradeTwo
@onready var upgrade_three: Button = $HUD/UpgradeOverlay/UpgradeThree
@onready var upgrade_reroll_button: Button = $HUD/UpgradeOverlay/RerollButton
@onready var hunt_goal_label: Label = $HUD/HuntGoal
@onready var build_label: Label = $HUD/BuildSummary
@onready var vibration_label: Label = $HUD/VibrationLabel
@onready var vibration_bar: ProgressBar = $HUD/VibrationBar
@onready var glyph_label: Label = $HUD/GlyphSummary
@onready var contract_label: Label = $HUD/ContractSummary
@onready var lure_button: Button = $HUD/LureButton
@onready var level_complete_overlay: ColorRect = $HUD/LevelCompleteOverlay
@onready var level_complete_title: Label = $HUD/LevelCompleteOverlay/Title
@onready var level_complete_detail: Label = $HUD/LevelCompleteOverlay/Detail
@onready var level_complete_rank: Label = $HUD/LevelCompleteOverlay/Rank
@onready var level_complete_build: Label = $HUD/LevelCompleteOverlay/Build
@onready var level_complete_button: Button = $HUD/LevelCompleteOverlay/ContinueButton
@onready var tutorial_banner: Panel = $HUD/TutorialBanner
@onready var tutorial_label: Label = $HUD/TutorialBanner/Label
@onready var contract_overlay: ColorRect = $HUD/ContractOverlay
@onready var contract_level_caption: Label = $HUD/ContractOverlay/LevelCaption
@onready var contract_one: Button = $HUD/ContractOverlay/ContractOne
@onready var contract_two: Button = $HUD/ContractOverlay/ContractTwo
@onready var contract_three: Button = $HUD/ContractOverlay/ContractThree
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
	FadenschnittTheme.apply(self)
	upgrade_one.pressed.connect(_choose_upgrade.bind(0))
	upgrade_two.pressed.connect(_choose_upgrade.bind(1))
	upgrade_three.pressed.connect(_choose_upgrade.bind(2))
	upgrade_reroll_button.pressed.connect(_reroll_upgrades)
	level_complete_button.pressed.connect(_continue_after_result)
	menu_button.pressed.connect(_open_main_menu)
	play_button.button_down.connect(_start_game_from_menu)
	how_to_button.button_down.connect(_show_how_to)
	settings_button.button_down.connect(_show_settings)
	update_button.button_down.connect(_open_android_update)
	how_to_back_button.pressed.connect(_close_menu_panel)
	settings_back_button.pressed.connect(_close_menu_panel)
	motion_button.pressed.connect(_toggle_reduced_motion)
	reset_button.pressed.connect(_confirm_or_prepare_new_run)
	lure_button.button_down.connect(_pluck_web)
	contract_one.button_down.connect(_choose_contract.bind(0))
	contract_two.button_down.connect(_choose_contract.bind(1))
	contract_three.button_down.connect(_choose_contract.bind(2))
	_reset_run()
	_show_main_menu(true)


func _process(delta: float) -> void:
	if menu_open:
		queue_redraw()
		return
	if game_over or upgrade_open or contract_open or level_complete:
		queue_redraw()
		return

	elapsed_time += delta
	preview_timer += delta
	insect_timer += delta
	wind_timer += delta
	lure_cooldown = maxf(0.0, lure_cooldown - delta)
	vibration = maxf(contract_vibration_floor, vibration - delta * (2.2 if flight_warnings.is_empty() else 1.35))
	glyph_refresh_timer -= delta
	if glyph_refresh_timer <= 0.0:
		glyph_refresh_timer = GLYPH_REFRESH_INTERVAL
		_refresh_web_glyphs()

	if preview_timer >= PREVIEW_INTERVAL:
		preview_timer = 0.0
		_select_next_preview()

	if insect_timer >= _current_spawn_interval() and not boss_active:
		insect_timer = 0.0
		_queue_insect_warning()

	if wind_timer >= WIND_INTERVAL:
		wind_timer = 0.0
		_apply_wind_gust()

	_update_spider(delta)
	_update_spider_animation(delta)
	_update_bite_timing(delta)
	_update_helper_spiders(delta)
	_update_flight_warnings(delta)
	_update_web_glyph_effects(delta)
	_update_threads(delta)
	_update_insects(delta)
	_try_emergency_reserve()
	_update_ambience(delta)
	_update_hud()
	queue_redraw()


func _input(event: InputEvent) -> void:
	# Handle menu taps before Android's touch-to-mouse emulation reaches the GUI.
	# This keeps the main navigation usable even when a full-screen Control or a
	# device-specific emulated mouse event would otherwise swallow the press.
	if not menu_open or not start_menu.visible:
		return
	var tap_position := Vector2.ZERO
	if event is InputEventScreenTouch:
		if not event.pressed:
			return
		tap_position = event.position
	elif event is InputEventMouseButton:
		if not event.pressed or event.button_index != MOUSE_BUTTON_LEFT:
			return
		tap_position = event.position
	else:
		return

	if _activate_menu_control_at(tap_position):
		get_viewport().set_input_as_handled()


func _activate_menu_control_at(tap_position: Vector2) -> bool:
	if how_to_overlay.visible:
		if how_to_back_button.get_global_rect().has_point(tap_position):
			_close_menu_panel()
		return true
	if settings_overlay.visible:
		if motion_button.get_global_rect().has_point(tap_position):
			_toggle_reduced_motion()
		elif reset_button.get_global_rect().has_point(tap_position):
			_confirm_or_prepare_new_run()
		elif settings_back_button.get_global_rect().has_point(tap_position):
			_close_menu_panel()
		return true
	if play_button.get_global_rect().has_point(tap_position):
		_start_game_from_menu()
	elif how_to_button.get_global_rect().has_point(tap_position):
		_show_how_to()
	elif settings_button.get_global_rect().has_point(tap_position):
		_show_settings()
	elif update_button.get_global_rect().has_point(tap_position):
		_open_android_update()
	else:
		return false
	return true


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if menu_open:
			_close_menu_panel()
		else:
			_open_main_menu()
		return
	if menu_open:
		return
	if contract_open:
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
	if bite_active:
		_resolve_bite_timing()
		return
	if game_over:
		_continue_after_result()
		return
	if level_complete:
		_continue_after_result()
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
	start_menu.visible = false
	menu_open = false
	menu_transitioning = false
	hud.visible = true
	menu_button.visible = true
	menu_card.scale = Vector2.ONE
	menu_card.modulate = Color.WHITE
	menu_hero.modulate = Color.WHITE
	menu_title.modulate = Color.WHITE
	if current_contract.is_empty() and not contract_open:
		_open_contract_selection()


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
	reset_confirmation_pending = false
	reset_button.text = "NEUE JAGD VORBEREITEN"


func _toggle_reduced_motion() -> void:
	reduced_motion = not reduced_motion
	motion_button.text = "BEWEGUNGSEFFEKTE: AUS" if reduced_motion else "BEWEGUNGSEFFEKTE: AN"


func _prepare_new_run() -> void:
	_reset_run()
	run_started = false
	play_button.text = "JAGD BEGINNEN"
	settings_overlay.visible = false
	status_label.text = "NEUE JAGD VORBEREITET"
	reset_confirmation_pending = false
	reset_button.text = "NEUE JAGD VORBEREITEN"


func _confirm_or_prepare_new_run() -> void:
	if not reset_confirmation_pending:
		reset_confirmation_pending = true
		reset_button.text = "NOCHMAL TIPPEN ZUM ZURÜCKSETZEN"
		return
	_prepare_new_run()


func _reset_run() -> void:
	anchors.clear()
	edges.clear()
	edge_health.clear()
	edge_age.clear()
	insects.clear()
	pollen_particles.clear()
	capture_flashes.clear()
	helper_spiders.clear()
	flight_warnings.clear()
	web_glyphs.clear()
	web_glyph_ids.clear()
	offered_contracts.clear()
	current_contract.clear()

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
	upgrade_rerolls_remaining = 1
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
	brood_nest_level = 0
	silk_menders_level = 0
	young_hunters_level = 0
	swarm_instinct_level = 0
	spider_queen_level = 0
	helper_action_timer = 0.0
	bite_active = false
	bite_target_id = -1
	bite_progress = 0.0
	bite_target_center = 0.62
	vibration = 0.0
	lure_cooldown = 0.0
	glyph_refresh_timer = 0.0
	glyph_effect_timer = 0.0
	glyph_combo = 0
	glyph_combo_timer = 0.0
	contract_open = false
	_reset_contract_modifiers()

	thread_strength = 100.0
	capture_radius = 15.0
	spider_speed = 260.0
	spider_rotation = 0.0
	integrity = 100.0
	silk_max = 80.0
	silk = silk_max
	food = 0
	xp = 0
	xp_target = 8
	level = 1
	upgrade_open = false
	upgrade_selecting = false
	game_over = false
	hunt_level = 1
	hunt_food = 0
	hunt_goal = 24
	_reset_contract_modifiers()
	boss_active = false
	level_complete = false
	run_complete = false
	tutorial_step = 0
	elapsed_time = 0.0
	preview_timer = 0.0
	insect_timer = 0.0
	wind_timer = 0.0
	lure_button.visible = false
	contract_overlay.visible = false
	preview_cursor = 11
	_create_pollen()
	upgrade_overlay.visible = false
	level_complete_overlay.visible = false
	tutorial_banner.visible = false
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
	if creates_thread and existing_edge >= 0:
		silk_cost *= 0.55
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
	if tutorial_step == 0 and hunt_level == 1:
		tutorial_step = 1
		_update_tutorial_banner()
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


func _sync_helper_spiders() -> void:
	var desired_count := brood_nest_level + swarm_instinct_level + spider_queen_level * 2
	while helper_spiders.size() < desired_count:
		var spawn_node := current_node if current_node >= 0 and current_node < anchors.size() else 0
		helper_spiders.append({
			"position": anchors[spawn_node],
			"node": spawn_node,
			"previous": -1,
			"from_node": -1,
			"to_node": -1,
			"progress": 0.0,
			"rotation": 0.0,
			"anim_time": randf() * 4.0
		})
	while helper_spiders.size() > desired_count:
		helper_spiders.pop_back()
	helper_action_timer = minf(helper_action_timer, 1.5)


func _update_helper_spiders(delta: float) -> void:
	if helper_spiders.is_empty():
		return
	for helper in helper_spiders:
		helper["anim_time"] = float(helper["anim_time"]) + delta * (6.0 + float(swarm_instinct_level))
		var from_node: int = helper["from_node"]
		var to_node: int = helper["to_node"]
		if from_node < 0 or to_node < 0 or from_node >= anchors.size() or to_node >= anchors.size():
			_start_helper_travel(helper)
			continue
		var a := anchors[from_node]
		var b := anchors[to_node]
		var distance := maxf(a.distance_to(b), 1.0)
		helper["rotation"] = (b - a).angle() - PI * 0.5
		helper["progress"] = float(helper["progress"]) + (175.0 * (1.0 + 0.12 * float(swarm_instinct_level)) / distance) * delta
		helper["position"] = a.lerp(b, minf(float(helper["progress"]), 1.0))
		if float(helper["progress"]) >= 1.0:
			helper["previous"] = from_node
			helper["node"] = to_node
			helper["position"] = anchors[to_node]
			_start_helper_travel(helper)
	helper_action_timer -= delta
	if helper_action_timer <= 0.0:
		_perform_helper_action()
		helper_action_timer = maxf(2.5, 8.0 - float(helper_spiders.size()) * 0.55 - float(young_hunters_level) * 0.8 - float(spider_queen_level) * 1.4)


func _start_helper_travel(helper: Dictionary) -> void:
	var node: int = helper["node"]
	if node < 0 or node >= anchors.size():
		node = 0
		helper["node"] = node
	var neighbors := _neighbors(node)
	if neighbors.is_empty():
		helper["from_node"] = -1
		helper["to_node"] = -1
		return
	var choices: Array[int] = []
	for neighbor in neighbors:
		if neighbor != int(helper["previous"]):
			choices.append(neighbor)
	if choices.is_empty():
		choices = neighbors
	helper["from_node"] = node
	helper["to_node"] = choices[randi() % choices.size()]
	helper["progress"] = 0.0


func _perform_helper_action() -> void:
	if young_hunters_level > 0:
		for i in range(insects.size()):
			if insects[i]["caught"] and not insects[i]["auto_collect"] and not insects[i]["boss"]:
				var prey_position: Vector2 = insects[i]["position"]
				_collect_insect(i, false)
				capture_flashes.append({"position": prey_position, "life": 0.75})
				status_label.text = "JUNGJÄGER – DIE BRUT WICKELT BEUTE EIN!"
				break
	if spider_queen_level > 0 and not bite_active:
		for i in range(insects.size()):
			if insects[i]["caught"] and insects[i]["boss"]:
				insects[i]["boss_hits"] = maxi(0, int(insects[i]["boss_hits"]) - 1)
				if int(insects[i]["boss_hits"]) <= 0:
					_collect_insect(i, false)
					status_label.text = "KÖNIGINNENBISS – ABSCHLUSSBEUTE BESIEGT!"
				else:
					status_label.text = "KÖNIGINNENBISS – NOCH %d" % int(insects[i]["boss_hits"])
				break
	var repair_amount := float(helper_spiders.size()) * 2.0 + float(silk_menders_level) * 8.0
	if repair_amount > 0.0:
		_repair_weakest_thread(repair_amount)


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
	glyph_refresh_timer = 0.0


func _edge_exists(a: int, b: int) -> bool:
	return _edge_index(a, b) >= 0


func _edge_index(a: int, b: int) -> int:
	for i in range(edges.size()):
		var edge := edges[i]
		if (edge.x == a and edge.y == b) or (edge.x == b and edge.y == a):
			return i
	return -1


func _refresh_web_glyphs() -> void:
	var adjacency: Dictionary = {}
	for i in range(edges.size()):
		if edge_health[i] <= 0.0:
			continue
		var edge := edges[i]
		if not adjacency.has(edge.x):
			adjacency[edge.x] = []
		if not adjacency.has(edge.y):
			adjacency[edge.y] = []
		var left_neighbors: Array = adjacency[edge.x]
		left_neighbors.append(edge.y)
		adjacency[edge.x] = left_neighbors
		var right_neighbors: Array = adjacency[edge.y]
		right_neighbors.append(edge.x)
		adjacency[edge.y] = right_neighbors

	var refreshed: Array[Dictionary] = []
	var refreshed_ids: Dictionary = {}
	var nodes: Array = adjacency.keys()
	nodes.sort()
	for a_variant in nodes:
		var a: int = a_variant
		var neighbors_a: Array = adjacency[a]
		for b_variant in neighbors_a:
			var b: int = b_variant
			if b <= a or not adjacency.has(b):
				continue
			var neighbors_b: Array = adjacency[b]
			for c_variant in neighbors_b:
				var c: int = c_variant
				if c <= b or not neighbors_a.has(c):
					continue
				var area := absf((anchors[b] - anchors[a]).cross(anchors[c] - anchors[a])) * 0.5
				if area < 6000.0 or area > 300000.0:
					continue
				var glyph_id := "triangle_%d_%d_%d" % [a, b, c]
				refreshed_ids[glyph_id] = true
				refreshed.append({"id": glyph_id, "type": "triangle", "nodes": [a, b, c]})

	for node_variant in nodes:
		var node: int = node_variant
		var degree := (adjacency[node] as Array).size()
		if degree < 4:
			continue
		var glyph_id := "heart_%d" % node
		refreshed_ids[glyph_id] = true
		refreshed.append({"id": glyph_id, "type": "heart", "node": node})

	for glyph in refreshed:
		if not web_glyph_ids.has(glyph["id"]):
			var glyph_name := "FANGTASCHE" if glyph["type"] == "triangle" else "SEIDENHERZ"
			status_label.text = "NETZGLYPHE ERWACHT: %s" % glyph_name
			hint_label.text = "GESCHLOSSENE FORMEN VERSTÄRKEN DEIN NETZ"
			break
	web_glyphs = refreshed
	web_glyph_ids = refreshed_ids


func _triangle_glyph_at(position: Vector2) -> Dictionary:
	for glyph in web_glyphs:
		if glyph["type"] != "triangle":
			continue
		var nodes: Array = glyph["nodes"]
		var polygon := PackedVector2Array([anchors[int(nodes[0])], anchors[int(nodes[1])], anchors[int(nodes[2])]])
		if Geometry2D.is_point_in_polygon(position, polygon):
			return glyph
	return {}


func _update_web_glyph_effects(delta: float) -> void:
	glyph_combo_timer = maxf(0.0, glyph_combo_timer - delta)
	if glyph_combo_timer <= 0.0:
		glyph_combo = 0
	var heart_count := 0
	for glyph in web_glyphs:
		if glyph["type"] == "heart":
			heart_count += 1
	if heart_count > 0:
		vibration = minf(100.0, vibration + float(heart_count) * 0.16 * delta)
	glyph_effect_timer -= delta
	if glyph_effect_timer > 0.0:
		return
	glyph_effect_timer = 3.5
	for glyph in web_glyphs:
		if glyph["type"] != "heart":
			continue
		var node: int = glyph["node"]
		for i in range(edges.size()):
			if edge_health[i] <= 0.0:
				continue
			if edges[i].x == node or edges[i].y == node:
				edge_health[i] = minf(thread_strength * new_thread_health_multiplier, edge_health[i] + 3.5)
		capture_flashes.append({"position": anchors[node], "life": 0.45})


func _pluck_web() -> void:
	if lure_cooldown > 0.0 or boss_active or upgrade_open or level_complete or game_over:
		return
	var active_edges := 0
	for health in edge_health:
		if health > 0.0:
			active_edges += 1
	if active_edges < 3:
		status_label.text = "BAUE ERST MINDESTENS 3 FÄDEN"
		return
	if _reactive_prey_count() > 0:
		status_label.text = "SICHERE ERST DIE AKTUELLE BEUTE"
		return
	lure_cooldown = LURE_COOLDOWN
	vibration = minf(100.0, vibration + 34.0)
	_queue_insect_warning(true, 0.0)
	_queue_insect_warning(true, 0.55)
	capture_flashes.append({"position": spider_position, "life": 0.9})
	status_label.text = "NETZ GEZUPFT – BEUTESCHWARM IM ANFLUG!"
	hint_label.text = "MEHR VIBRATION = BESSERE BEUTE, ABER MEHR GEFAHR"


func _reset_contract_modifiers() -> void:
	contract_spawn_multiplier = 1.0
	contract_damage_multiplier = 1.0
	contract_food_multiplier = 1.0
	contract_xp_multiplier = 1.0
	contract_silk_multiplier = 1.0
	contract_escape_multiplier = 1.0
	contract_speed_multiplier = 1.0
	contract_special_chance = 0.06 + minf(0.08, float(hunt_level - 1) * 0.015)
	contract_preferred_special = ""
	contract_vibration_floor = 0.0
	contract_thread_cost_multiplier = 1.0
	contract_rare_bonus = 0.0


func _open_contract_selection() -> void:
	_reset_contract_modifiers()
	current_contract.clear()
	offered_contracts.clear()
	var candidates: Array[Dictionary] = HUNT_CONTRACTS.duplicate()
	while offered_contracts.size() < 3 and not candidates.is_empty():
		var selected := randi() % candidates.size()
		offered_contracts.append(candidates[selected])
		candidates.remove_at(selected)
	contract_open = true
	contract_overlay.visible = true
	contract_level_caption.text = "JAGDLEVEL %d" % hunt_level
	var cards: Array[Button] = [contract_one, contract_two, contract_three]
	for i in range(cards.size()):
		_configure_contract_card(cards[i], offered_contracts[i])
		# Keep the menu-start tap from falling through into a contract card.
		cards[i].disabled = true
		cards[i].scale = Vector2(0.84, 0.84)
		cards[i].modulate = Color(1.0, 1.0, 1.0, 0.0)
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(cards[i], "scale", Vector2.ONE, 0.3).set_delay(float(i) * 0.07).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(cards[i], "modulate", Color.WHITE, 0.18).set_delay(float(i) * 0.07)
	status_label.text = "WÄHLE EINEN JAGDVERTRAG"
	hint_label.text = "RISIKO UND BELOHNUNG GELTEN BIS ZUM MINIBOSS"
	await get_tree().process_frame
	if contract_open:
		for card in cards:
			card.disabled = false


func _configure_contract_card(card: Button, contract: Dictionary) -> void:
	var title := card.get_node("Title") as Label
	title.text = contract["title"]
	title.add_theme_font_size_override("font_size", 35 if String(contract["title"]).length() > 15 else 40)
	(card.get_node("Risk") as Label).text = String(contract["risk"]).to_upper()
	(card.get_node("Reward") as Label).text = String(contract["reward"]).to_upper()
	(card.get_node("Special") as Label).text = "%s  ·  ANTIPPEN" % contract["special"]
	var portrait := card.get_node("Portrait") as TextureRect
	portrait.texture = FadenschnittTheme.contract_portrait(String(contract.get("preferred", "beetle")))


func _choose_contract(choice: int) -> void:
	if not contract_open or choice < 0 or choice >= offered_contracts.size():
		return
	var cards: Array[Button] = [contract_one, contract_two, contract_three]
	for card in cards:
		card.disabled = true
	current_contract = offered_contracts[choice]
	contract_spawn_multiplier = float(current_contract.get("spawn", 1.0))
	contract_damage_multiplier = float(current_contract.get("damage", 1.0))
	contract_food_multiplier = float(current_contract.get("food", 1.0))
	contract_xp_multiplier = float(current_contract.get("xp", 1.0))
	contract_silk_multiplier = float(current_contract.get("silk", 1.0))
	contract_escape_multiplier = float(current_contract.get("escape", 1.0))
	contract_speed_multiplier = float(current_contract.get("speed", 1.0))
	contract_special_chance = float(current_contract.get("special_chance", 0.06))
	contract_preferred_special = String(current_contract.get("preferred", ""))
	contract_vibration_floor = float(current_contract.get("vibration_floor", 0.0))
	contract_thread_cost_multiplier = float(current_contract.get("thread_cost", 1.0))
	contract_rare_bonus = float(current_contract.get("rare", 0.0))
	hunt_goal = maxi(hunt_food + 1, roundi(float(hunt_goal) * float(current_contract.get("goal", 1.0))))
	vibration = maxf(vibration, contract_vibration_floor)
	contract_open = false
	contract_overlay.visible = false
	status_label.text = "VERTRAG AKTIV: %s" % current_contract["title"]
	hint_label.text = "%s · %s" % [current_contract["risk"], current_contract["reward"]]
	if hunt_level == 1 and upgrade_levels.is_empty():
		tutorial_step = 0
		_update_tutorial_banner()
	_update_hud()
	if xp >= xp_target and not upgrade_open:
		_open_upgrade()


func _thread_cost(a: Vector2, b: Vector2) -> float:
	return clampf(8.0 + a.distance_to(b) / 40.0, 10.0, 28.0) * thread_cost_multiplier * contract_thread_cost_multiplier


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
	var free_fallback := -1
	for attempt in range(base_anchor_count):
		preview_cursor = (preview_cursor + 1) % base_anchor_count
		if anchors[preview_cursor].distance_to(spider_position) < 110.0:
			continue
		var edge_index := _edge_index(current_node, preview_cursor)
		var creates_thread := edge_index < 0 or edge_health[edge_index] <= 0.0
		if not creates_thread:
			free_fallback = preview_cursor
		var cost := _thread_cost(spider_position, anchors[preview_cursor]) if creates_thread else 0.0
		if silk + 0.01 >= cost:
			preview_anchor = preview_cursor
			return
	preview_anchor = free_fallback


func _spawn_insect() -> void:
	_spawn_insect_from_spec(_create_insect_spec())


func _create_insect_spec(force_valuable: bool = false) -> Dictionary:
	var special_chance := contract_special_chance + (0.1 if force_valuable else 0.0)
	if randf() < special_chance:
		var special_kind := contract_preferred_special
		if special_kind.is_empty() or randf() > 0.72:
			var special_kinds := ["beetle", "dragonfly", "firefly"]
			special_kind = special_kinds[randi() % special_kinds.size()]
		return _create_special_insect_spec(special_kind)
	var risk_bonus := vibration * 0.0008
	var roll := clampf(randf() + rare_spawn_bonus + contract_rare_bonus + risk_bonus, 0.0, 0.999)
	if force_valuable:
		roll = maxf(roll, randf_range(0.58, 0.96))
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
		escape_time = 5.0
		struggle_damage = 6.0
		auto_collect = false
	elif roll > 0.84 and roll <= 0.97:
		kind = "moth"
		value = 4
		radius = randf_range(13.0, 17.0)
		speed = randf_range(115.0, 155.0)
		required_strength = 55.0
		escape_time = 3.5
		struggle_damage = 13.0
		auto_collect = false
	elif roll > 0.97:
		kind = "bee"
		value = 8
		radius = randf_range(15.0, 19.0)
		speed = randf_range(190.0, 245.0)
		required_strength = 108.0
		escape_time = 2.2
		struggle_damage = 30.0
		auto_collect = false
	var from_left := randf() < 0.5
	var y := randf_range(340.0, 1530.0)
	speed *= (1.0 + float(hunt_level - 1) * 0.07) * (1.0 + vibration * 0.0015) * contract_speed_multiplier
	return {
		"kind": kind,
		"value": value,
		"radius": radius,
		"speed": speed,
		"required_strength": required_strength,
		"escape_time": escape_time,
		"struggle_damage": struggle_damage,
		"auto_collect": auto_collect,
		"from_left": from_left,
		"y": y,
		"vertical_speed": randf_range(-14.0, 14.0),
		"passes": 0,
		"special": false
	}


func _create_special_insect_spec(kind: String) -> Dictionary:
	var spec := {
		"kind": kind,
		"value": 6,
		"radius": 14.0,
		"speed": 170.0,
		"required_strength": 42.0,
		"escape_time": 3.0,
		"struggle_damage": 10.0,
		"auto_collect": false,
		"passes": 0,
		"special": true
	}
	match kind:
		"beetle":
			spec.merge({"value": 10, "radius": 23.0, "speed": 105.0, "required_strength": 118.0, "escape_time": 3.6, "struggle_damage": 34.0}, true)
		"dragonfly":
			spec.merge({"value": 7, "radius": 14.0, "speed": 315.0, "required_strength": 44.0, "escape_time": 1.9, "struggle_damage": 12.0, "passes": 2}, true)
		"firefly":
			spec.merge({"value": 5, "radius": 11.0, "speed": 128.0, "required_strength": 22.0, "escape_time": 5.0, "struggle_damage": 3.0}, true)
	var from_left := randf() < 0.5
	var speed_scale := (1.0 + float(hunt_level - 1) * 0.07) * (1.0 + vibration * 0.0015) * contract_speed_multiplier
	spec["speed"] = float(spec["speed"]) * speed_scale
	spec["from_left"] = from_left
	spec["y"] = randf_range(360.0, 1510.0)
	spec["vertical_speed"] = randf_range(-10.0, 10.0)
	return spec


func _spawn_insect_from_spec(spec: Dictionary) -> void:
	var from_left: bool = spec["from_left"]
	var direction := 1.0 if from_left else -1.0
	insects.append({
		"id": next_insect_id,
		"kind": spec["kind"],
		"position": Vector2(-35.0 if from_left else 1115.0, spec["y"]),
		"velocity": Vector2(float(spec["speed"]) * direction, spec["vertical_speed"]),
		"radius": spec["radius"],
		"value": spec["value"],
		"caught": false,
		"edge": -1,
		"timer": 0.0,
		"phase": randf() * TAU,
		"required_strength": spec["required_strength"],
		"escape_time": spec["escape_time"],
		"struggle_damage": spec["struggle_damage"],
		"auto_collect": spec["auto_collect"],
		"boss": false,
		"boss_hits": 1,
		"glyph_capture": false,
		"special": bool(spec.get("special", false)),
		"passes_left": int(spec.get("passes", 0)),
		"ignored_edges": {}
	})
	next_insect_id += 1


func _queue_insect_warning(force_valuable: bool = false, extra_delay: float = 0.0) -> void:
	if flight_warnings.size() >= 4 or boss_active:
		return
	var spec := _create_insect_spec(force_valuable)
	if not bool(spec["auto_collect"]) and _reactive_prey_count() + _pending_reactive_warning_count() >= _reactive_prey_limit():
		return
	var warning_duration := 0.72
	match String(spec["kind"]):
		"fly": warning_duration = 0.9
		"moth": warning_duration = 1.08
		"bee": warning_duration = 1.3
		"beetle": warning_duration = 1.45
		"dragonfly": warning_duration = 0.82
		"firefly": warning_duration = 1.15
	flight_warnings.append({
		"spec": spec,
		"timer": warning_duration + extra_delay,
		"duration": warning_duration + extra_delay
	})


func _update_flight_warnings(delta: float) -> void:
	for i in range(flight_warnings.size() - 1, -1, -1):
		flight_warnings[i]["timer"] = float(flight_warnings[i]["timer"]) - delta
		if float(flight_warnings[i]["timer"]) <= 0.0:
			if not boss_active and not level_complete:
				_spawn_insect_from_spec(flight_warnings[i]["spec"])
			flight_warnings.remove_at(i)


func _current_spawn_interval() -> float:
	return clampf((INSECT_SPAWN_INTERVAL - vibration * 0.004) * contract_spawn_multiplier, 0.85, 1.9)


func _reactive_prey_limit() -> int:
	return 2 if hunt_level <= 2 else 3


func _reactive_prey_count() -> int:
	var count := 0
	for insect in insects:
		if not bool(insect["auto_collect"]) and not bool(insect["boss"]):
			count += 1
	return count


func _pending_reactive_warning_count() -> int:
	var count := 0
	for warning in flight_warnings:
		if not bool(warning["spec"]["auto_collect"]):
			count += 1
	return count


func _spawn_boss_moth() -> void:
	_spawn_wasp_miniboss()


func _spawn_wasp_miniboss() -> void:
	if boss_active or level_complete:
		return
	boss_active = true
	flight_warnings.clear()
	var boss_cycle := ["wasp_queen", "titan_beetle", "razor_hornet"]
	var boss_kind: String = boss_cycle[(hunt_level - 1) % boss_cycle.size()]
	var boss_stats: Dictionary = {
		"wasp_queen": {"speed": 158.0, "radius": 32.0, "value": 16, "strength": 82.0, "escape": 4.2, "struggle": 25.0, "hits": 4},
		"titan_beetle": {"speed": 108.0, "radius": 38.0, "value": 20, "strength": 115.0, "escape": 5.1, "struggle": 38.0, "hits": 5},
		"razor_hornet": {"speed": 232.0, "radius": 29.0, "value": 18, "strength": 70.0, "escape": 2.8, "struggle": 22.0, "hits": 4}
	}[boss_kind]
	var from_left := randf() < 0.5
	var direction := 1.0 if from_left else -1.0
	insects.append({
		"id": next_insect_id,
		"kind": boss_kind,
		"position": Vector2(-90.0 if from_left else 1170.0, randf_range(520.0, 1260.0)),
		"velocity": Vector2((float(boss_stats["speed"]) + float(hunt_level - 1) * 8.0) * direction, randf_range(-28.0, 28.0)),
		"radius": boss_stats["radius"],
		"value": boss_stats["value"],
		"caught": false,
		"edge": -1,
		"timer": 0.0,
		"phase": randf() * TAU,
		"required_strength": float(boss_stats["strength"]) + float(hunt_level - 1) * 7.0,
		"escape_time": boss_stats["escape"],
		"struggle_damage": float(boss_stats["struggle"]) + float(hunt_level - 1) * 2.5,
		"auto_collect": false,
		"boss": true,
		"boss_hits": int(boss_stats["hits"]) + floori(float(hunt_level - 1) * 0.34),
		"glyph_capture": false,
		"ignored_edges": {}
	})
	next_insect_id += 1
	status_label.text = "ACHTUNG – %s IM ANFLUG!" % _boss_display_name(boss_kind)
	hint_label.text = "FANGEN · ANSPRINGEN · IM GOLDENEN FENSTER BEISSEN"


func _boss_display_name(kind: String) -> String:
	return {
		"wasp": "WESPE",
		"wasp_queen": "WESPENKÖNIGIN",
		"titan_beetle": "TITAN-KÄFER",
		"razor_hornet": "KLINGENHORNISSE"
	}.get(kind, "MINIBOSS")


func _update_insects(delta: float) -> void:
	for i in range(insects.size() - 1, -1, -1):
		var insect := insects[i]
		if insect["caught"]:
			if bite_active and int(insect["id"]) == bite_target_id:
				var pinned_edge: int = insect["edge"]
				if pinned_edge >= 0 and pinned_edge < edges.size():
					var pinned_segment := edges[pinned_edge]
					insect["position"] = anchors[pinned_segment.x].lerp(anchors[pinned_segment.y], insect["phase"])
				continue
			insect["timer"] += delta
			var edge_index: int = insect["edge"]
			if edge_index >= 0 and edge_index < edges.size():
				var edge := edges[edge_index]
				insect["position"] = anchors[edge.x].lerp(anchors[edge.y], insect["phase"])
				var vibration_strain := 1.0 + vibration * 0.003
				edge_health[edge_index] = maxf(0.0, edge_health[edge_index] - float(insect["struggle_damage"]) * struggle_damage_multiplier * vibration_strain * contract_damage_multiplier * delta)
			if insect["auto_collect"] and float(insect["timer"]) >= 0.42:
				status_label.text = "+1 XP - KLEINE MUECKE"
				_collect_insect(i)
			elif edge_index < 0 or edge_index >= edge_health.size() or edge_health[edge_index] <= 0.0:
				_escape_insect(i, "FADEN GERISSEN")
			elif float(insect["timer"]) >= float(insect["escape_time"]) * escape_time_multiplier * contract_escape_multiplier:
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
			var capture_glyph := _triangle_glyph_at(position)
			if not capture_glyph.is_empty():
				effective_requirement *= 0.78
			if insect["kind"] in ["beetle", "titan_beetle"] and capture_glyph.is_empty() and strong_silk_level <= 0:
				effective_requirement *= 1.35
			if edge_health[caught_edge] + 0.01 >= effective_requirement:
				insect["caught"] = true
				insect["edge"] = caught_edge
				insect["timer"] = 0.0
				insect["phase"] = _segment_ratio(position, caught_edge)
				insect["glyph_capture"] = not capture_glyph.is_empty()
				if not bool(insect["auto_collect"]) and tutorial_step == 2 and hunt_level == 1:
					tutorial_step = 3
					_update_tutorial_banner()
				if insect["glyph_capture"]:
					insect["escape_time"] = float(insect["escape_time"]) * 1.45
				edge_health[caught_edge] = maxf(0.0, edge_health[caught_edge] - float(insect["radius"]) * 0.7)
				capture_flashes.append({"position": position, "life": 0.55})
				vibration = minf(100.0, vibration + 2.0 + float(insect["value"]) * 0.5)
				if insect["boss"]:
					status_label.text = "%s FEST – JETZT ANSPRINGEN!" % _boss_display_name(String(insect["kind"]))
				elif insect["glyph_capture"]:
					status_label.text = "FANGTASCHE SCHNAPPT ZU – KOMBO MÖGLICH!"
				else:
					status_label.text = "BEUTE FESTGEHALTEN - JETZT ANTIPPEN!"
				hint_label.text = "DANACH IM GOLDENEN BISSFENSTER TIPPEN" if insect["boss"] else "DER RING ZEIGT DIE VERBLEIBENDE FLUCHTZEIT"
			else:
				insect["ignored_edges"][caught_edge] = true
				var break_force := 0.68 if insect["kind"] in ["beetle", "titan_beetle"] else 0.42
				edge_health[caught_edge] = maxf(0.0, edge_health[caught_edge] - effective_requirement * break_force * contract_damage_multiplier)
				insect["velocity"].y += randf_range(-85.0, 85.0)
				status_label.text = "PANZERKÄFER BRICHT DURCH – FANGTASCHE ODER STARKE SEIDE!" if insect["kind"] in ["beetle", "titan_beetle"] else "ZU SCHWACH - BEUTE BRICHT DURCH"
		elif position.x < -90.0 or position.x > 1170.0 or position.y < 180.0 or position.y > 1700.0:
			if insect["boss"]:
				_damage_thread_by_wasp(String(insect["kind"]))
				var from_left := randf() < 0.5
				var direction := 1.0 if from_left else -1.0
				insect["position"] = Vector2(-90.0 if from_left else 1170.0, randf_range(480.0, 1320.0))
				var pass_speed := maxf(105.0, absf(float(velocity.x)) * 1.04)
				insect["velocity"] = Vector2(pass_speed * direction, randf_range(-34.0, 34.0))
				insect["ignored_edges"] = {}
				status_label.text = "%s GREIFT ERNEUT AN!" % _boss_display_name(String(insect["kind"]))
			elif insect["kind"] == "dragonfly" and int(insect.get("passes_left", 0)) > 0:
				insect["passes_left"] = int(insect["passes_left"]) - 1
				var reenter_left := position.x > 540.0
				var reenter_direction := 1.0 if reenter_left else -1.0
				insect["position"] = Vector2(-55.0 if reenter_left else 1135.0, randf_range(360.0, 1510.0))
				insect["velocity"] = Vector2(absf(float(insect["velocity"].x)) * reenter_direction, randf_range(-18.0, 18.0))
				insect["ignored_edges"] = {}
				status_label.text = "LIBELLE WENDET – NOCH %d ANFLÜGE" % (int(insect["passes_left"]) + 1)
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
		if is_boss:
			_begin_bite_timing(insect_id)
			return
		_collect_insect(prey_index)
		status_label.text = "BEUTE EINGEWICKELT"
		if captured_edge >= 0 and captured_edge < edges.size() and edge_health[captured_edge] > 0.0:
			if pounce_repair_amount > 0.0:
				edge_health[captured_edge] = minf(thread_strength * new_thread_health_multiplier, edge_health[captured_edge] + pounce_repair_amount)
		_resume_spider_after_capture(captured_edge, captured_phase)
	else:
		status_label.text = "ZU SPAET - BEUTE IST WEG"
		current_node = _nearest_anchor(spider_position)
		spider_position = anchors[current_node]
		previous_node = -1
		_start_auto_travel()
	pounce_target_id = -1


func _begin_bite_timing(insect_id: int) -> void:
	bite_active = true
	bite_target_id = insect_id
	bite_progress = 0.0
	bite_target_center = randf_range(0.46, 0.76)
	status_label.text = "BISS BEREIT"
	hint_label.text = "TIPPE, WENN DER ZEIGER IM GOLDENEN FELD IST"


func _update_bite_timing(delta: float) -> void:
	if not bite_active:
		return
	bite_progress += delta / BITE_SWEEP_DURATION
	if bite_progress >= 1.0:
		bite_progress = 1.0
		_resolve_bite_timing()


func _resolve_bite_timing() -> void:
	if not bite_active:
		return
	var insect_index := _insect_index_by_id(bite_target_id)
	bite_active = false
	if insect_index < 0:
		bite_target_id = -1
		pounce_target_id = -1
		return
	var insect := insects[insect_index]
	var captured_edge: int = insect["edge"]
	var captured_phase: float = insect["phase"]
	var timing_distance := absf(bite_progress - bite_target_center)
	var trap_window_bonus := minf(0.09, maxf(0.0, escape_time_multiplier - 1.0) * 0.08)
	if bool(insect.get("glyph_capture", false)):
		trap_window_bonus += 0.04
	var perfect_window := BITE_PERFECT_WINDOW + trap_window_bonus
	var good_padding := BITE_GOOD_PADDING + trap_window_bonus * 0.65
	var damage := 0
	var result_message := "BISS VERPASST – DER MINIBOSS ZERREISST DEN FADEN!"
	if timing_distance <= perfect_window * 0.5:
		damage = boss_damage + 1
		xp += 2
		silk = minf(silk_max, silk + 5.0)
		result_message = "PERFEKTER BISS! +2 XP · +5 SEIDE"
	elif timing_distance <= perfect_window * 0.5 + good_padding:
		damage = boss_damage
		result_message = "BISS GETROFFEN!"
	else:
		if captured_edge >= 0 and captured_edge < edge_health.size():
			edge_health[captured_edge] = maxf(0.0, edge_health[captured_edge] - (28.0 + float(hunt_level - 1) * 3.0) * struggle_damage_multiplier)
	if damage > 0:
		insect["boss_hits"] = maxi(0, int(insect["boss_hits"]) - damage)
	if int(insect["boss_hits"]) <= 0:
		_collect_insect(insect_index)
		status_label.text = "%s BEZWUNGEN!" % _boss_display_name(String(insect["kind"]))
	else:
		result_message += " NOCH %d" % int(insect["boss_hits"])
		_escape_insect(insect_index, result_message)
		_resume_spider_after_capture(captured_edge, captured_phase)
	bite_target_id = -1
	pounce_target_id = -1


func _resume_spider_after_capture(captured_edge: int, captured_phase: float) -> void:
	if captured_edge >= 0 and captured_edge < edges.size() and edge_health[captured_edge] > 0.0:
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


func _damage_thread_by_wasp(boss_kind: String = "wasp") -> void:
	var candidates: Array[int] = []
	for i in range(edge_health.size()):
		if edge_health[i] > 0.0:
			candidates.append(i)
	if candidates.is_empty():
		return
	var strike_count := 2 if boss_kind == "titan_beetle" else 1
	var strike_damage := 20.0 if boss_kind == "razor_hornet" else 12.0
	for strike in range(mini(strike_count, candidates.size())):
		var candidate_index := randi() % candidates.size()
		var edge_index := candidates[candidate_index]
		candidates.remove_at(candidate_index)
		edge_health[edge_index] = maxf(0.0, edge_health[edge_index] - strike_damage - float(hunt_level - 1) * 2.0)
		var edge := edges[edge_index]
		capture_flashes.append({"position": anchors[edge.x].lerp(anchors[edge.y], 0.5), "life": 0.8})


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
	var was_glyph_capture: bool = insect.get("glyph_capture", false)
	var reward_multiplier := food_multiplier * contract_food_multiplier
	var xp_multiplier := contract_xp_multiplier
	var local_silk_multiplier := silk_gain_multiplier * contract_silk_multiplier
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
	if was_glyph_capture:
		glyph_combo = mini(5, glyph_combo + 1)
		glyph_combo_timer = 6.0
		reward_multiplier *= 1.0 + float(glyph_combo) * 0.08
		xp_multiplier *= 1.0 + float(glyph_combo) * 0.05
	var reward := maxi(1, roundi(float(value) * reward_multiplier))
	if not insect["auto_collect"] and randf() < double_food_chance:
		reward *= 2
		status_label.text = "KRITISCHER FANG - DOPPELTE NAHRUNG!"
	food += reward
	hunt_food += reward
	xp += maxi(1, roundi(float(value) * xp_multiplier))
	var silk_gain := (4.0 + float(value) * 2.0) * local_silk_multiplier
	silk = minf(silk_max, silk + silk_gain)
	vibration = minf(100.0, vibration + 1.5 + float(value) * 0.65)
	if not was_auto and tutorial_step == 3 and hunt_level == 1:
		tutorial_step = 4
		_update_tutorial_banner()
	match String(insect["kind"]):
		"firefly":
			vibration = maxf(contract_vibration_floor, vibration - 28.0)
			silk = minf(silk_max, silk + 12.0 * contract_silk_multiplier)
			status_label.text = "GLÜHWÜRMCHEN – NETZ BERUHIGT · +12 SEIDE"
		"beetle":
			_repair_weakest_thread(16.0)
			status_label.text = "PANZERKÄFER – SCHWÄCHSTER FADEN VERSTÄRKT"
		"dragonfly":
			xp += 2
			status_label.text = "LIBELLENFANG – +2 REAKTIONS-XP"
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
	if hunt_food >= hunt_goal and not boss_active and _boss_build_ready():
		_spawn_boss_moth()
	if xp >= xp_target and not level_complete:
		_open_upgrade()


func _boss_build_ready() -> bool:
	# The first hunt teaches the build loop before testing it against a boss.
	return hunt_level > 1 or level >= 3


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
	run_complete = hunt_level >= 5
	boss_active = false
	bite_active = false
	bite_target_id = -1
	insects.clear()
	flight_warnings.clear()
	vibration = maxf(0.0, vibration - 30.0)
	lure_button.visible = false
	level_complete_overlay.visible = true
	level_complete_title.text = "JAGD ERFOLGREICH" if run_complete else "LEVEL %d GESCHAFFT" % hunt_level
	var contract_name := String(current_contract.get("title", "NORMALE JAGD"))
	level_complete_rank.text = "NETZRANG  %s" % _calculate_net_rank()
	level_complete_build.text = _build_summary_text()
	if run_complete:
		level_complete_detail.text = "5 Jagdgebiete überstanden\n%d Nahrung gesammelt · Abschlussbeute besiegt" % food
		level_complete_button.text = "NEUE JAGD BEGINNEN"
	else:
		level_complete_detail.text = "%d Nahrung gesammelt\n%s erfüllt · Miniboss besiegt" % [hunt_food, contract_name]
		level_complete_button.text = "WEITER ZU LEVEL %d" % (hunt_level + 1)
	level_complete_button.visible = true
	status_label.text = "JAGDAUFTRAG ERFÜLLT"
	hint_label.text = "DEIN NETZ UND BUILD WERDEN ÜBERNOMMEN"


func _calculate_net_rank() -> String:
	var active_threads := 0
	for health in edge_health:
		if health > 0.0:
			active_threads += 1
	var score := integrity + float(active_threads) * 2.0 + float(web_glyphs.size()) * 9.0
	if score >= 150.0:
		return "S"
	if score >= 120.0:
		return "A"
	if score >= 90.0:
		return "B"
	if score >= 60.0:
		return "C"
	return "D"


func _continue_after_result() -> void:
	if game_over or run_complete:
		_reset_run()
		run_started = true
		game_over = false
		level_complete = false
		level_complete_overlay.visible = false
		_open_contract_selection()
	else:
		_start_next_hunt_level()


func _start_next_hunt_level() -> void:
	hunt_level += 1
	hunt_food = 0
	hunt_goal = roundi(24.0 * pow(1.32, hunt_level - 1))
	boss_active = false
	emergency_reserve_used = false
	level_complete = false
	run_complete = false
	level_complete_overlay.visible = false
	upgrade_rerolls_remaining = 1
	insect_timer = 0.0
	flight_warnings.clear()
	vibration = maxf(0.0, vibration - 25.0)
	lure_cooldown = 2.0
	tutorial_banner.visible = false
	status_label.text = "LEVEL %d - NEUER JAGDAUFTRAG" % hunt_level
	hint_label.text = "SAMMLE NAHRUNG UND LOCKE DEN NÄCHSTEN MINIBOSS AN"
	_update_hud()
	_open_contract_selection()


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

	if active_count == 0 and not edges.is_empty() and silk < 10.0:
		_end_run()
	elif not game_over:
		var recovery_rate := 0.45 if _reactive_prey_count() > 0 else 0.8
		silk = minf(silk_max, silk + delta * recovery_rate)


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
	var vibration_strain := 1.0 + vibration * 0.004
	edge_health[chosen] = maxf(0.0, edge_health[chosen] - 18.0 * wind_damage_multiplier * vibration_strain * contract_damage_multiplier)
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
	upgrade_build_hint.text = "%s  ·  NEU MISCHEN BEVORZUGT DEINE PFADE" % _build_summary_text()
	upgrade_reroll_button.visible = true
	upgrade_reroll_button.disabled = upgrade_rerolls_remaining <= 0
	upgrade_reroll_button.text = "NEU MISCHEN · %d" % upgrade_rerolls_remaining
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
			total_weight += _upgrade_offer_weight(candidate)
		var roll := randf() * total_weight
		var selected_index := 0
		for i in range(candidates.size()):
			roll -= _upgrade_offer_weight(candidates[i])
			if roll <= 0.0:
				selected_index = i
				break
		result.append(candidates[selected_index])
		candidates.remove_at(selected_index)
	return result


func _upgrade_offer_weight(upgrade: Dictionary) -> float:
	var base_weight := float(upgrade["weight"])
	var build_name := String(upgrade["build"])
	var build_investment := 0
	for owned in UpgradeDB.all():
		if String(owned["build"]) == build_name:
			build_investment += int(upgrade_levels.get(owned["id"], 0))
	# Existing choices gently steer future offers without locking other paths out.
	return base_weight * minf(2.25, 1.0 + float(build_investment) * 0.3)


func _reroll_upgrades() -> void:
	if not upgrade_open or upgrade_selecting or upgrade_rerolls_remaining <= 0:
		return
	upgrade_rerolls_remaining -= 1
	var previous_ids: Array[String] = []
	for upgrade in offered_upgrades:
		previous_ids.append(String(upgrade["id"]))
	for attempt in range(4):
		offered_upgrades = _roll_upgrade_offer()
		var changed := false
		for upgrade in offered_upgrades:
			if not previous_ids.has(String(upgrade["id"])):
				changed = true
				break
		if changed:
			break
	var cards: Array[Button] = [upgrade_one, upgrade_two, upgrade_three]
	for i in range(mini(cards.size(), offered_upgrades.size())):
		_configure_upgrade_card(cards[i], offered_upgrades[i])
	upgrade_reroll_button.disabled = true
	upgrade_reroll_button.text = "NEU MISCHEN · 0"


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
	xp_target = roundi(8.0 * pow(1.45, level - 1))
	upgrade_open = false
	upgrade_overlay.visible = false
	upgrade_reroll_button.visible = false
	upgrade_selecting = false
	_update_hud()
	if hunt_food >= hunt_goal and not boss_active and _boss_build_ready():
		_spawn_boss_moth()


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
		"brood_nest":
			brood_nest_level += 1
			_sync_helper_spiders()
		"silk_menders":
			silk_menders_level += 1
			_perform_helper_action()
		"young_hunters":
			young_hunters_level += 1
			helper_action_timer = minf(helper_action_timer, 1.0)
		"swarm_instinct":
			swarm_instinct_level += 1
			spider_speed *= 1.12
			_sync_helper_spiders()
		"spider_queen":
			spider_queen_level = 1
			_sync_helper_spiders()


func _end_run() -> void:
	game_over = true
	bite_active = false
	bite_target_id = -1
	travel_from = -1
	travel_to = -1
	flight_warnings.clear()
	lure_button.visible = false
	level_complete_overlay.visible = true
	level_complete_title.text = "NETZ KOLLABIERT"
	level_complete_rank.text = "JAGD BEENDET"
	level_complete_build.text = _build_summary_text()
	level_complete_detail.text = "Level %d erreicht · %d Nahrung gesammelt\nAlle Fäden sind gerissen und die Seide ist erschöpft." % [hunt_level, food]
	level_complete_button.text = "NEUE JAGD BEGINNEN"
	level_complete_button.visible = true
	status_label.text = "DAS NETZ IST KOLLABIERT"
	hint_label.text = "BAUE KÜRZER ODER SICHERE DIR EINE NOTRESERVE"


func _update_hud() -> void:
	integrity_label.text = "NETZ  %d %%" % roundi(integrity)
	if integrity <= 25.0:
		integrity_label.add_theme_color_override("font_color", Color("ef6a42"))
	else:
		integrity_label.add_theme_color_override("font_color", Color("f4c556"))
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
	vibration_bar.max_value = 100.0
	vibration_bar.value = vibration
	var vibration_state := "RUHIG"
	if vibration >= 70.0:
		vibration_state = "GEFAEHRLICH"
	elif vibration >= 35.0:
		vibration_state = "AKTIV"
	vibration_label.text = "VIBRATION %d %% · %s" % [roundi(vibration), vibration_state]
	var triangle_count := 0
	var heart_count := 0
	for glyph in web_glyphs:
		if glyph["type"] == "triangle":
			triangle_count += 1
		elif glyph["type"] == "heart":
			heart_count += 1
	if triangle_count == 0 and heart_count == 0:
		glyph_label.text = "NETZGLYPHEN: NOCH KEINE"
	else:
		glyph_label.text = "FANGTASCHEN %d · SEIDENHERZEN %d" % [triangle_count, heart_count]
		if glyph_combo > 1:
			glyph_label.text += " · KOMBO x%d" % glyph_combo
	lure_button.visible = active_threads >= 3 and not boss_active and not level_complete and not game_over
	vibration_label.visible = lure_button.visible or vibration >= 10.0
	vibration_bar.visible = vibration_label.visible
	glyph_label.visible = triangle_count > 0 or heart_count > 0
	lure_button.disabled = lure_cooldown > 0.0 or upgrade_open or _reactive_prey_count() > 0
	if _reactive_prey_count() > 0:
		lure_button.text = "ERST BEUTE SICHERN"
	else:
		lure_button.text = "ZUPFEN %.0f s" % ceilf(lure_cooldown) if lure_cooldown > 0.0 else "NETZ ZUPFEN"
	if boss_active:
		var active_boss_name := "MINIBOSS"
		for insect in insects:
			if insect["boss"]:
				active_boss_name = _boss_display_name(String(insect["kind"]))
				break
		hunt_goal_label.text = "LEVEL %d · %s" % [hunt_level, active_boss_name]
	elif hunt_food >= hunt_goal and not _boss_build_ready():
		hunt_goal_label.text = "JAGDZIEL ERFÜLLT  ·  NOCH %d UPGRADE BIS BOSS" % maxi(0, 3 - level)
	else:
		hunt_goal_label.text = "JAGDZIEL L%d  ·  NAHRUNG %d/%d" % [hunt_level, hunt_food, hunt_goal]
	build_label.text = _build_summary_text()
	build_label.visible = not upgrade_levels.is_empty()
	contract_label.text = "JAGDVERTRAG: %s" % String(current_contract.get("title", "WIRD GEWÄHLT"))
	contract_label.visible = false
	if tutorial_step == 1 and triangle_count > 0 and hunt_level == 1:
		tutorial_step = 2
		_update_tutorial_banner()
	elif hunt_level != 1 and tutorial_banner.visible:
		tutorial_banner.visible = false


func _update_tutorial_banner() -> void:
	if hunt_level != 1 or tutorial_step >= 4:
		tutorial_banner.visible = false
		return
	tutorial_banner.visible = true
	match tutorial_step:
		0:
			tutorial_label.text = "1/4  TIPPE AUF DEN LEUCHTENDEN ZIELPUNKT"
		1:
			tutorial_label.text = "2/4  BAUE EIN DREIECK ALS FANGTASCHE"
		2:
			tutorial_label.text = "3/4  TIERE FLIEGEN VOM RAND INS NETZ"
		3:
			tutorial_label.text = "4/4  RING AM TIER = FLUCHTZEIT · TIER ANTIPPEN"


func _build_summary_text() -> String:
	if upgrade_levels.is_empty():
		return "BUILD: NOCH OFFEN"
	var counts := {"FESTUNG": 0, "FALLE": 0, "JÄGERIN": 0, "ÖKONOMIE": 0, "BRUT": 0}
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
	_draw_web_glyphs()
	_draw_insects()
	_draw_capture_flashes()
	_draw_preview()
	if not upgrade_open:
		_draw_helper_spiders()
		var spider_draw_position := spider_position + Vector2(0.0, -54.0) if bite_active else spider_position
		_draw_spider(spider_draw_position)
		_draw_bite_timing()


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
	var node_degrees: Dictionary = {}
	for i in range(edges.size()):
		var edge := edges[i]
		var health_ratio := clampf(edge_health[i] / maxf(thread_strength, 1.0), 0.0, 1.0)
		if health_ratio <= 0.0:
			continue
		var a := anchors[edge.x]
		var b := anchors[edge.y]
		node_degrees[edge.x] = int(node_degrees.get(edge.x, 0)) + 1
		node_degrees[edge.y] = int(node_degrees.get(edge.y, 0)) + 1
		draw_line(a, b, Color(CREAM, 0.08 + 0.12 * health_ratio), 11.0, true)
		var thread_texture := THREAD_REINFORCED_TEXTURE if strong_silk_level > 0 else THREAD_NATURAL_TEXTURE
		var thread_height := 39.0 + float(strong_silk_level) * 2.0 if strong_silk_level > 0 else 29.0
		_draw_thread_texture(thread_texture, a, b, thread_height, Color(1.0, 1.0, 1.0, 0.52 + 0.48 * health_ratio))
		if sticky_level > 0:
			var sticky_alpha := minf(0.9, 0.48 + float(sticky_level) * 0.12)
			_draw_thread_texture(THREAD_STICKY_TEXTURE, a, b, 43.0 + float(sticky_level) * 2.0, Color(0.88, 0.97, 1.0, sticky_alpha * health_ratio))
	for node_variant in node_degrees.keys():
		var node: int = node_variant
		var knot_scale := 0.23 if int(node_degrees[node]) >= 2 else 0.15
		var knot_tint := Color(0.88, 0.97, 1.0, 0.9) if sticky_level > 0 else Color(1.0, 1.0, 1.0, 0.88)
		_draw_texture_centered(THREAD_KNOT_TEXTURE, anchors[node], knot_scale, 0.0, knot_tint)


func _draw_web_glyphs() -> void:
	var pulse := 0.5 + sin(elapsed_time * 3.2) * 0.5
	var visible_hearts := 0
	for glyph in web_glyphs:
		if glyph["type"] == "triangle":
			var nodes: Array = glyph["nodes"]
			var polygon := PackedVector2Array([
				anchors[int(nodes[0])],
				anchors[int(nodes[1])],
				anchors[int(nodes[2])]
			])
			draw_colored_polygon(polygon, Color(SKY, 0.045 + pulse * 0.025))
			var outline := PackedVector2Array([polygon[0], polygon[1], polygon[2], polygon[0]])
			draw_polyline(outline, Color(SKY, 0.48 + pulse * 0.18), 4.0, true)
			var center := (polygon[0] + polygon[1] + polygon[2]) / 3.0
			draw_circle(center, 15.0 + pulse * 3.0, Color(DARK_MOSS, 0.72))
			draw_arc(center, 17.0 + pulse * 3.0, 0.0, TAU, 20, Color(SKY, 0.85), 3.0, true)
			draw_string(ThemeDB.fallback_font, center + Vector2(-9.0, 7.0), "△", HORIZONTAL_ALIGNMENT_CENTER, 18.0, 20, CREAM)
		elif glyph["type"] == "heart":
			if visible_hearts >= 3:
				continue
			visible_hearts += 1
			var position: Vector2 = anchors[int(glyph["node"])]
			draw_circle(position, 20.0 + pulse * 3.0, Color(HONEY, 0.055 + pulse * 0.035))
			draw_arc(position, 23.0 + pulse * 3.0, 0.0, TAU, 20, Color(HONEY, 0.46), 3.0, true)
			draw_circle(position, 5.0, Color(HONEY, 0.82))


func _draw_thread_texture(texture: Texture2D, a: Vector2, b: Vector2, height: float, modulate: Color) -> void:
	var direction := b - a
	var length := direction.length()
	if length <= 0.5:
		return
	draw_set_transform(a, direction.angle(), Vector2.ONE)
	draw_texture_rect(texture, Rect2(Vector2(0.0, -height * 0.5), Vector2(length, height)), false, modulate)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_insects() -> void:
	for insect in insects:
		var position: Vector2 = insect["position"]
		var velocity: Vector2 = insect["velocity"]
		var rotation := velocity.angle() + PI * 0.5
		var kind: String = insect["kind"]
		var is_bite_target := bite_active and int(insect["id"]) == bite_target_id
		var texture := FLY_TEXTURE
		var scale := 0.045
		var insect_tint := Color.WHITE if not insect["caught"] else Color(1.0, 0.78, 0.62, 1.0)
		if kind == "gnat":
			scale = 0.025
		elif kind == "moth":
			texture = MOTH_TEXTURE
			scale = 0.066
		elif kind == "bee":
			texture = BEE_TEXTURE
			scale = 0.062
		elif kind == "beetle":
			texture = BEETLE_TEXTURE
			scale = 0.062
			insect_tint = Color.WHITE if not insect["caught"] else Color(0.9, 0.64, 0.5, 1.0)
			var shell_pulse := 1.0 + sin(elapsed_time * 4.0 + float(insect["phase"])) * 0.04
			draw_circle(position, 39.0 * shell_pulse, Color(BERRY, 0.2))
		elif kind == "dragonfly":
			texture = DRAGONFLY_TEXTURE
			scale = 0.058
			insect_tint = Color.WHITE if not insect["caught"] else Color(0.8, 0.76, 0.67, 1.0)
		elif kind == "firefly":
			texture = FIREFLY_TEXTURE
			scale = 0.052
			insect_tint = Color.WHITE if not insect["caught"] else Color(1.0, 0.78, 0.52, 1.0)
			var glow := 0.5 + sin(elapsed_time * 7.0 + float(insect["phase"])) * 0.5
			draw_circle(position, 55.0 + glow * 14.0, Color(HONEY, 0.08 + glow * 0.08))
			draw_circle(position, 18.0 + glow * 4.0, Color(HONEY, 0.34 + glow * 0.25))
		elif kind in ["wasp", "wasp_queen", "titan_beetle", "razor_hornet"]:
			texture = WASP_TEXTURE
			scale = 0.105
			if kind == "wasp_queen":
				texture = WASP_QUEEN_TEXTURE
				scale = 0.094
			elif kind == "titan_beetle":
				texture = TITAN_BEETLE_TEXTURE
				scale = 0.092
			elif kind == "razor_hornet":
				texture = RAZOR_HORNET_TEXTURE
				scale = 0.098
		if insect["boss"]:
			if kind == "wasp":
				scale = 0.12
			if not is_bite_target:
				var boss_pulse := 1.0 + sin(elapsed_time * 5.0) * 0.06
				var trail_direction := -velocity.normalized()
				draw_line(position + trail_direction * 62.0, position + trail_direction * 145.0, Color(ORANGE, 0.28), 16.0, true)
				draw_circle(position, 92.0 * boss_pulse, Color(ORANGE, 0.17))
				draw_arc(position, 94.0 * boss_pulse, 0.0, TAU, 48, Color(HONEY, 0.82), 6.0, true)
			var hit_count: int = insect["boss_hits"]
			if not is_bite_target:
				for hit in range(hit_count):
					draw_circle(position + Vector2((float(hit) - float(hit_count - 1) * 0.5) * 22.0, -108.0), 7.0, ORANGE)
		if insect["caught"] and not insect["auto_collect"] and not is_bite_target:
			scale *= 0.9
			var remaining := clampf(1.0 - float(insect["timer"]) / float(insect["escape_time"]), 0.0, 1.0)
			var ring_color := Color(HONEY, 0.96) if remaining > 0.38 else Color(ORANGE, 1.0)
			var ring_radius := 88.0 if insect["boss"] else 59.0
			draw_circle(position, ring_radius - 1.0, Color(DARK_MOSS, 0.34))
			draw_arc(position, ring_radius, -PI * 0.5, -PI * 0.5 + TAU * remaining, 48, ring_color, 8.0, true)
		_draw_texture_centered(texture, position, scale, rotation, insect_tint)
		if kind in ["beetle", "dragonfly", "firefly"] and not insect["caught"]:
			var special_names := {"beetle": "PANZERKÄFER", "dragonfly": "LIBELLE", "firefly": "GLÜHWÜRMCHEN"}
			draw_string(FADENSCHNITT_DISPLAY_FONT, position + Vector2(-76.0, -58.0), special_names[kind], HORIZONTAL_ALIGNMENT_CENTER, 152.0, 17, CREAM)
		if insect["caught"] and not insect["auto_collect"] and not is_bite_target:
			draw_arc(position, 72.0 + sin(elapsed_time * 10.0) * 4.0, 0.0, TAU, 32, Color(CREAM, 0.5), 3.0, true)


func _draw_bite_timing() -> void:
	if not bite_active:
		return
	var insect_index := _insect_index_by_id(bite_target_id)
	if insect_index < 0:
		return
	var position: Vector2 = insects[insect_index]["position"]
	var radius := 132.0
	var start_angle := -PI * 0.5
	var perfect_start := start_angle + TAU * (bite_target_center - BITE_PERFECT_WINDOW * 0.5)
	var perfect_end := start_angle + TAU * (bite_target_center + BITE_PERFECT_WINDOW * 0.5)
	var marker_angle := start_angle + TAU * bite_progress
	draw_arc(position, radius, start_angle, start_angle + TAU, 64, Color(CREAM, 0.24), 12.0, true)
	draw_arc(position, radius, perfect_start, perfect_end, 24, Color(HONEY, 1.0), 18.0, true)
	var marker_position := position + Vector2.from_angle(marker_angle) * radius
	draw_circle(marker_position, 16.0, Color(CREAM, 0.96))
	draw_circle(marker_position, 8.0, ORANGE)
	var hit_count: int = insects[insect_index]["boss_hits"]
	for hit in range(hit_count):
		draw_circle(position + Vector2((float(hit) - float(hit_count - 1) * 0.5) * 24.0, -158.0), 8.0, ORANGE)
		draw_arc(position + Vector2((float(hit) - float(hit_count - 1) * 0.5) * 24.0, -158.0), 8.0, 0.0, TAU, 16, CREAM, 2.0, true)
	draw_string(FADENSCHNITT_DISPLAY_FONT, position + Vector2(-88.0, 166.0), "JETZT BEISSEN", HORIZONTAL_ALIGNMENT_CENTER, 176.0, 24, CREAM)


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


func _draw_helper_spiders() -> void:
	var helper_count := helper_spiders.size()
	for i in range(helper_spiders.size()):
		var helper := helper_spiders[i]
		var position: Vector2 = helper["position"]
		if helper_count > 1:
			var formation_angle := TAU * float(i) / float(helper_count) + float(helper["rotation"])
			var formation_radius := minf(30.0, 15.0 + float(helper_count) * 3.0)
			position += Vector2.from_angle(formation_angle) * formation_radius
		var pulse := 1.0 + sin(float(helper["anim_time"]) * 1.7 + float(i)) * 0.06
		draw_circle(position + Vector2(0.0, 9.0), 25.0, Color(DARK_MOSS, 0.18))
		draw_circle(position, 18.0 * pulse, Color(HONEY, 0.12))
		var tint := Color(1.0, 0.82, 0.52, 1.0) if spider_queen_level <= 0 else Color(1.0, 0.9, 0.58, 1.0)
		_draw_spider_sheet_frame(SPIDER_CRAWL_TEXTURE, floori(float(helper["anim_time"])) % 4, position, 0.115 * pulse, float(helper["rotation"]), Vector2.ONE, tint)


func _draw_spider_sheet_frame(texture: Texture2D, frame: int, position: Vector2, scale: float, rotation: float, stretch: Vector2, modulate: Color = Color.WHITE) -> void:
	var cell := texture.get_size() * 0.5
	var column := frame % 2
	var row := frame / 2
	var source := Rect2(Vector2(column * cell.x, row * cell.y), cell)
	var target := Rect2(-cell * 0.5, cell)
	draw_set_transform(position, rotation, Vector2(scale * stretch.x, scale * stretch.y))
	draw_texture_rect_region(texture, target, source, modulate)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_texture_centered(texture: Texture2D, position: Vector2, scale: float, rotation: float, modulate: Color = Color.WHITE) -> void:
	draw_set_transform(position, rotation, Vector2(scale, scale))
	draw_texture(texture, -texture.get_size() * 0.5, modulate)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
