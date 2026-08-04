extends Node2D

const DESIGN_SIZE := Vector2(1080.0, 1920.0)
const PLAY_RECT := Rect2(48.0, 300.0, 984.0, 1330.0)
const SURVIVAL_TIME := 90.0
const GRAVITY := 330.0
const MAX_PULL := 265.0
const MIN_PULL := 34.0
const LAUNCH_SCALE := 4.35
const SPIDER_RADIUS := 34.0
const CRAWL_SPEED := 105.0
const AIM_SLOW_TIME := 1.0
const AUTO_LAUNCH_TIME := 3.2

const PINE := Color("#102A24")
const MOSS := Color("#315A45")
const LICHEN := Color("#A7C46A")
const SILK_COLOR := Color("#F2E8D5")
const ORANGE := Color("#F28C28")
const CORAL := Color("#E3564A")
const SKY := Color("#79C4D8")

const BACKGROUND: Texture2D = preload("res://assets/backgrounds/forest-fadenschnitt-v1.png")
const SPIDER: Texture2D = preload("res://assets/sprites/spider-fadenschnitt-v1.png")
const FLY: Texture2D = preload("res://assets/sprites/fly-fadenschnitt-v1.png")
const MOTH: Texture2D = preload("res://assets/sprites/moth-fadenschnitt-v1.png")
const WASP: Texture2D = preload("res://assets/sprites/wasp-fadenschnitt-v1.png")
const BEETLE: Texture2D = preload("res://assets/ui/contracts/beetle-fadenschnitt-v1.png")
const DRAGONFLY: Texture2D = preload("res://assets/ui/contracts/dragonfly-fadenschnitt-v1.png")
const THREAD: Texture2D = preload("res://assets/web/thread-natural-v1.png")
const KNOT: Texture2D = preload("res://assets/web/thread-knot-v1.png")
const DISPLAY_FONT: Font = preload("res://assets/fonts/BarlowCondensed-SemiBold.ttf")

var branch_anchors: Array[Vector2] = [
	Vector2(120, 390), Vector2(405, 320), Vector2(770, 335), Vector2(970, 520),
	Vector2(990, 890), Vector2(950, 1330), Vector2(785, 1570), Vector2(505, 1610),
	Vector2(220, 1540), Vector2(80, 1260), Vector2(90, 830)
]
var threads: Array[Dictionary] = []
var insects: Array[Dictionary] = []
var particles: Array[Dictionary] = []

var spider_position := Vector2(520, 980)
var spider_velocity := Vector2.ZERO
var launch_origin := Vector2.ZERO
var airborne := false
var aiming := false
var aim_pointer := Vector2.ZERO
var flight_time := 0.0
var aim_cost := 0.0
var aim_hold_time := 0.0
var air_catches := 0
var bounces_this_flight := 0
var support_thread := 0
var support_t := 0.5
var support_direction := 1.0
var launch_support_thread := 0
var launch_support_t := 0.5
var successful_landings := 0
var rescue_count := 0

var hunger := 100.0
var silk := 100.0
var score := 0
var combo := 0
var best_combo := 0
var elapsed := 0.0
var spawn_timer := 0.0
var wave_index := 0
var spawn_queue: Array[Dictionary] = []
var next_insect_id := 1
var game_finished := false
var status_time := 0.0

@onready var survival_label: Label = $HUD/Survival
@onready var hunger_label: Label = $HUD/Hunger
@onready var silk_label: Label = $HUD/Silk
@onready var score_label: Label = $HUD/Score
@onready var combo_label: Label = $HUD/Combo
@onready var status_label: Label = $HUD/Status
@onready var hint_label: Label = $HUD/Hint
@onready var menu_button: Button = $HUD/MenuButton
@onready var result_overlay: ColorRect = $HUD/Result
@onready var result_title: Label = $HUD/Result/Title
@onready var result_detail: Label = $HUD/Result/Detail
@onready var retry_button: Button = $HUD/Result/Retry
@onready var result_menu_button: Button = $HUD/Result/Menu


func _ready() -> void:
	menu_button.pressed.connect(_go_to_menu)
	retry_button.pressed.connect(_reset_game)
	result_menu_button.pressed.connect(_go_to_menu)
	_style_buttons()
	score_label.visible = false
	_reset_game()


func _style_buttons() -> void:
	for button in [menu_button, retry_button, result_menu_button]:
		var normal := StyleBoxFlat.new()
		normal.bg_color = SILK_COLOR if button == retry_button else Color(PINE, 0.92)
		normal.border_color = ORANGE if button == retry_button else SILK_COLOR
		normal.set_border_width_all(3)
		normal.set_corner_radius_all(18)
		button.add_theme_stylebox_override("normal", normal)
		var pressed := normal.duplicate() as StyleBoxFlat
		pressed.bg_color = ORANGE
		pressed.border_color = SILK_COLOR
		button.add_theme_stylebox_override("pressed", pressed)
		button.add_theme_stylebox_override("hover", pressed)


func _reset_game() -> void:
	threads.clear()
	insects.clear()
	particles.clear()
	spawn_queue.clear()
	_add_thread(Vector2(190, 980), Vector2(890, 980), true, true)
	spider_position = Vector2(520, 980)
	spider_velocity = Vector2.ZERO
	launch_origin = spider_position
	airborne = false
	aiming = false
	aim_hold_time = 0.0
	flight_time = 0.0
	air_catches = 0
	bounces_this_flight = 0
	support_thread = 0
	support_t = 0.471
	support_direction = 1.0
	successful_landings = 0
	rescue_count = 0
	hunger = 100.0
	silk = 100.0
	score = 0
	combo = 0
	best_combo = 0
	elapsed = 0.0
	spawn_timer = 4.6
	wave_index = 0
	next_insect_id = 1
	game_finished = false
	result_overlay.visible = false
	status_label.text = "SPINNE HALTEN · ZURÜCKZIEHEN · LOSLASSEN"
	hint_label.text = "TRIFF BEUTE IM FLUG. LANDE AUF ÄSTEN ODER FÄDEN.\nDEIN FLUGWEG WIRD ZUM NEUEN NETZ."
	_update_hud()
	queue_redraw()


func _process(delta: float) -> void:
	if game_finished:
		queue_redraw()
		return
	if aiming:
		aim_hold_time += delta
		_update_aim(aim_pointer)
	var aim_scale := 1.0
	if aiming and aim_hold_time < AIM_SLOW_TIME:
		aim_scale = 0.34
	elif aiming and aim_hold_time < 2.2:
		aim_scale = lerpf(0.34, 1.0, (aim_hold_time - AIM_SLOW_TIME) / 1.2)
	var world_delta := delta * aim_scale
	elapsed += world_delta
	spawn_timer += world_delta
	hunger = maxf(0.0, hunger - world_delta * (1.16 + elapsed * 0.006))
	if status_time > 0.0:
		status_time = maxf(0.0, status_time - delta)
		if status_time <= 0.0 and not aiming:
			status_label.text = "HALTEN · ZIEHEN · LOSLASSEN"

	if spawn_timer >= _wave_interval():
		spawn_timer = 0.0
		_queue_wave()
	_update_spawn_queue(world_delta)
	_update_insects(world_delta)
	_update_threads(world_delta)
	_update_particles(world_delta)
	if airborne:
		_update_flight(world_delta)
	elif not aiming:
		_update_ground_movement(world_delta)
	if aiming and aim_hold_time >= AUTO_LAUNCH_TIME:
		_release_aim(aim_pointer)
	if hunger <= 0.0:
		_finish_game(false, "AUSGEHUNGERT")
	elif elapsed >= SURVIVAL_TIME:
		_finish_game(true, "MORGEN ERREICHT")
	_update_hud()
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if game_finished or airborne:
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			_begin_aim(event.position)
		else:
			_release_aim(event.position)
	elif event is InputEventScreenDrag:
		_update_aim(event.position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_begin_aim(event.position)
		else:
			_release_aim(event.position)
	elif event is InputEventMouseMotion and aiming:
		_update_aim(event.position)


func _begin_aim(pointer: Vector2) -> void:
	if pointer.distance_to(spider_position) > 105.0:
		return
	aiming = true
	aim_hold_time = 0.0
	aim_pointer = pointer
	aim_cost = 0.0
	for insect in insects:
		if insect["kind"] == "dragonfly":
			insect["dodged_this_aim"] = false
	status_label.text = "ZIEHE GEGEN DIE FLUGRICHTUNG"


func _update_aim(pointer: Vector2) -> void:
	if not aiming:
		return
	var pull := spider_position - pointer
	if pull.length() > MAX_PULL:
		pointer = spider_position - pull.normalized() * MAX_PULL
	aim_pointer = pointer
	aim_cost = _launch_cost((spider_position - aim_pointer).length(), aim_hold_time)
	status_label.text = "SPRUNGKOSTEN %.0f SEIDE · AUTO %.1fs" % [aim_cost, maxf(0.0, AUTO_LAUNCH_TIME - aim_hold_time)]


func _release_aim(pointer: Vector2) -> void:
	if not aiming:
		return
	_update_aim(pointer)
	var pull := spider_position - aim_pointer
	var held_for := aim_hold_time
	aiming = false
	if pull.length() < MIN_PULL:
		status_label.text = "WEITER ZURÜCKZIEHEN"
		status_time = 1.2
		return
	var cost := _launch_cost(pull.length(), held_for)
	if silk + 0.01 < cost:
		status_label.text = "ZU WENIG SEIDE FÜR DIESEN SPRUNG"
		status_time = 1.5
		return
	silk -= cost
	launch_origin = spider_position
	launch_support_thread = support_thread
	launch_support_t = support_t
	spider_velocity = pull.limit_length(MAX_PULL) * LAUNCH_SCALE
	airborne = true
	flight_time = 0.0
	air_catches = 0
	bounces_this_flight = 0
	status_label.text = "FLUGLINIE HALTEN"
	Input.vibrate_handheld(18)


func _launch_cost(pull_length: float, hold_time: float = aim_hold_time) -> float:
	return 4.0 + clampf(pull_length, 0.0, MAX_PULL) / 29.0 + maxf(0.0, hold_time - AIM_SLOW_TIME) * 4.0


func _update_flight(delta: float) -> void:
	flight_time += delta
	var previous := spider_position
	spider_velocity.y += GRAVITY * delta
	spider_position += spider_velocity * delta
	_collect_insects_on_path(previous, spider_position)
	if flight_time >= 0.15:
		var landing := _find_landing(previous, spider_position)
		if bool(landing.get("hit", false)):
			_land_at(landing["position"], landing)
			return
	if spider_position.x < -100.0 or spider_position.x > 1180.0 or spider_position.y < 220.0 or spider_position.y > 1760.0:
		_rescue_or_fall()


func _find_landing(from: Vector2, to: Vector2) -> Dictionary:
	var best_t := 2.0
	var best_position := Vector2.ZERO
	var best_kind := ""
	var best_index := -1
	for anchor_index in range(branch_anchors.size()):
		var anchor := branch_anchors[anchor_index]
		if _distance_to_segment(anchor, from, to) <= 42.0:
			var t := _segment_ratio(anchor, from, to)
			if t < best_t:
				best_t = t
				best_position = anchor
				best_kind = "anchor"
				best_index = anchor_index
	for thread_index in range(threads.size()):
		var thread := threads[thread_index]
		if float(thread["health"]) <= 0.0:
			continue
		var intersection := _segment_intersection(from, to, thread["a"], thread["b"])
		if bool(intersection.get("hit", false)) and float(intersection["t"]) < best_t:
			best_t = intersection["t"]
			best_position = intersection["position"]
			best_kind = "thread"
			best_index = thread_index
	return {"hit": best_t <= 1.0, "position": best_position, "kind": best_kind, "index": best_index}


func _land_at(position: Vector2, landing: Dictionary = {}) -> void:
	spider_position = position
	spider_velocity = Vector2.ZERO
	airborne = false
	var new_thread := -1
	if launch_origin.distance_to(position) >= 70.0:
		new_thread = _add_thread(launch_origin, position, false)
	if landing.get("kind", "") == "thread":
		support_thread = int(landing.get("index", 0))
		support_t = _segment_ratio(position, threads[support_thread]["a"], threads[support_thread]["b"])
	elif new_thread >= 0:
		support_thread = new_thread
		support_t = 1.0
		support_direction = -1.0
	else:
		support_thread = _nearest_thread_to_point(position)
		if support_thread >= 0:
			support_t = _segment_ratio(position, threads[support_thread]["a"], threads[support_thread]["b"])
	successful_landings += 1
	rescue_count = maxi(0, rescue_count - 1)
	if successful_landings >= 3 and threads.size() > 0 and bool(threads[0].get("starter", false)) and support_thread != 0:
		threads[0]["health"] = 0.0
	var landing_bonus := air_catches * maxi(1, combo)
	if landing_bonus > 0:
		score += landing_bonus
		status_label.text = "SICHER GELANDET · +%d FLUGBONUS" % landing_bonus
	else:
		status_label.text = "SICHER GELANDET · NEUER FADEN"
	status_time = 1.5
	air_catches = 0
	_create_burst(position, LICHEN)
	Input.vibrate_handheld(24)


func _rescue_or_fall() -> void:
	airborne = false
	spider_velocity = Vector2.ZERO
	air_catches = 0
	combo = 0
	var rescue_cost := 15.0 + rescue_count * 7.0
	if silk >= rescue_cost:
		silk -= rescue_cost
		rescue_count += 1
		hunger = maxf(0.0, hunger - 7.0)
		spider_position = launch_origin
		support_thread = launch_support_thread
		support_t = launch_support_t
		status_label.text = "RETTUNGSFADEN · -%.0f SEIDE · NAECHSTER WIRD TEURER" % rescue_cost
		status_time = 2.0
		_create_burst(spider_position, CORAL)
		Input.vibrate_handheld(65)
	else:
		_finish_game(false, "ABGESTÜRZT")


func _add_thread(a: Vector2, b: Vector2, fixed: bool, starter: bool = false) -> int:
	if a.distance_to(b) < 45.0:
		return -1
	threads.append({"a": a, "b": b, "health": 100.0, "fixed": fixed, "starter": starter, "age": 0.0})
	return threads.size() - 1


func _wave_interval() -> float:
	return clampf(6.2 - elapsed * 0.012, 4.8, 6.2)


func _update_ground_movement(delta: float) -> void:
	if support_thread < 0 or support_thread >= threads.size():
		return
	var thread := threads[support_thread]
	if float(thread["health"]) <= 0.0:
		return
	var length: float = (thread["b"] - thread["a"]).length()
	if length < 1.0:
		return
	support_t += support_direction * CRAWL_SPEED * delta / length
	if support_t >= 1.0:
		support_t = 1.0
		support_direction = -1.0
	elif support_t <= 0.0:
		support_t = 0.0
		support_direction = 1.0
	spider_position = thread["a"].lerp(thread["b"], support_t)


func _update_threads(delta: float) -> void:
	for index in range(threads.size()):
		var thread := threads[index]
		thread["age"] = float(thread.get("age", 0.0)) + delta
		if not bool(thread["fixed"]) and float(thread["age"]) > 18.0:
			thread["health"] = maxf(0.0, float(thread["health"]) - delta * 0.32)
	if successful_landings >= 3 and threads.size() > 0 and support_thread != 0 and bool(threads[0].get("starter", false)):
		threads[0]["health"] = 0.0


func _nearest_thread_to_point(point: Vector2) -> int:
	var best := -1
	var best_distance := INF
	for index in range(threads.size()):
		if float(threads[index]["health"]) <= 0.0:
			continue
		var distance := _distance_to_segment(point, threads[index]["a"], threads[index]["b"])
		if distance < best_distance:
			best_distance = distance
			best = index
	return best


func _queue_spawn(kind: String, delay: float, y: float, from_left: bool) -> void:
	spawn_queue.append({"kind": kind, "delay": delay, "y": y, "from_left": from_left})


func _queue_wave() -> void:
	wave_index += 1
	var left := wave_index % 2 == 0
	if elapsed < 18.0:
		_queue_spawn("fly", 0.0, 650.0, left)
		_queue_spawn("fly", 0.48, 810.0, left)
		_queue_spawn("fly", 0.96, 970.0, left)
	elif wave_index % 4 == 0:
		_queue_spawn("wasp", 0.0, 760.0, left)
		_queue_spawn("fly", 0.7, 1040.0, not left)
	elif wave_index % 4 == 1:
		_queue_spawn("moth", 0.0, 620.0, left)
		_queue_spawn("moth", 0.72, 1080.0, not left)
	elif wave_index % 4 == 2:
		_queue_spawn("fly", 0.0, 620.0, left)
		_queue_spawn("beetle", 0.55, 850.0, left)
		_queue_spawn("fly", 1.1, 1080.0, left)
	else:
		_queue_spawn("dragonfly", 0.0, 700.0, left)
		_queue_spawn("dragonfly", 0.82, 1050.0, not left)


func _update_spawn_queue(delta: float) -> void:
	for index in range(spawn_queue.size() - 1, -1, -1):
		spawn_queue[index]["delay"] = float(spawn_queue[index]["delay"]) - delta
		if float(spawn_queue[index]["delay"]) <= 0.0:
			var entry := spawn_queue[index]
			_spawn_insect_kind(entry["kind"], float(entry["y"]), bool(entry["from_left"]))
			spawn_queue.remove_at(index)


func _spawn_insect_kind(kind: String, y: float, from_left: bool) -> void:
	var specs := {
		"fly": [26.0, 185.0, 1, 9.0, 5.0],
		"moth": [34.0, 140.0, 3, 16.0, 8.0],
		"wasp": [31.0, 260.0, 5, 22.0, 11.0],
		"beetle": [36.0, 125.0, 5, 20.0, 10.0],
		"dragonfly": [30.0, 295.0, 6, 18.0, 12.0]
	}
	var spec: Array = specs.get(kind, specs["fly"])
	var direction := 1.0 if from_left else -1.0
	insects.append({
		"id": next_insect_id, "kind": kind,
		"position": Vector2(-55.0 if from_left else 1135.0, y),
		"velocity": Vector2(float(spec[1]) * direction, randf_range(-10.0, 10.0)),
		"radius": float(spec[0]), "reward": int(spec[2]), "food": float(spec[3]), "silk": float(spec[4]),
		"phase": randf() * TAU, "hit_threads": {}, "hit_cooldown": 0.0, "dodged_this_aim": false
	})
	next_insect_id += 1


func _spawn_insect() -> void:
	var roll := randf()
	var kind := "fly"
	var radius := 26.0
	var speed := randf_range(150.0, 205.0)
	var reward := 1
	var food_gain := 9.0
	var silk_gain := 5.0
	if elapsed > 18.0 and roll > 0.66:
		kind = "moth"
		radius = 34.0
		speed = randf_range(115.0, 155.0)
		reward = 3
		food_gain = 16.0
		silk_gain = 8.0
	if elapsed > 32.0 and roll > 0.88:
		kind = "wasp"
		radius = 31.0
		speed = randf_range(220.0, 285.0)
		reward = 5
		food_gain = 22.0
		silk_gain = 11.0
	var from_left := randf() < 0.5
	var direction := 1.0 if from_left else -1.0
	insects.append({
		"id": next_insect_id,
		"kind": kind,
		"position": Vector2(-55.0 if from_left else 1135.0, randf_range(390.0, 1540.0)),
		"velocity": Vector2(speed * direction, randf_range(-12.0, 12.0)),
		"radius": radius,
		"reward": reward,
		"food": food_gain,
		"silk": silk_gain,
		"phase": randf() * TAU,
		"hit_threads": {}
	})
	next_insect_id += 1


func _update_insects(delta: float) -> void:
	for i in range(insects.size() - 1, -1, -1):
		var insect := insects[i]
		insect["hit_cooldown"] = maxf(0.0, float(insect.get("hit_cooldown", 0.0)) - delta)
		var previous: Vector2 = insect["position"]
		var velocity: Vector2 = insect["velocity"]
		if insect["kind"] == "moth":
			velocity.y += sin(elapsed * 4.0 + float(insect["phase"])) * 42.0 * delta
		elif insect["kind"] == "dragonfly" and aiming and aim_hold_time > 0.65 and not bool(insect.get("dodged_this_aim", false)):
			velocity = velocity.rotated(0.62 if i % 2 == 0 else -0.62)
			insect["dodged_this_aim"] = true
		insect["velocity"] = velocity
		insect["position"] = previous + velocity * delta
		for thread_index in range(threads.size()):
			if float(threads[thread_index]["health"]) <= 0.0 or insect["hit_threads"].has(thread_index):
				continue
			if _segment_intersection(previous, insect["position"], threads[thread_index]["a"], threads[thread_index]["b"]).get("hit", false):
				insect["hit_threads"][thread_index] = true
				insect["velocity"] = insect["velocity"] * 0.72
				if insect["kind"] == "wasp" and not bool(threads[thread_index]["fixed"]):
					threads[thread_index]["health"] = maxf(0.0, float(threads[thread_index]["health"]) - 24.0)
				_create_burst(insect["position"], CORAL if insect["kind"] == "wasp" else SKY)
		if insect["position"].x < -100.0 or insect["position"].x > 1180.0 or insect["position"].y < 250.0 or insect["position"].y > 1700.0:
			insects.remove_at(i)


func _collect_insects_on_path(from: Vector2, to: Vector2) -> void:
	for i in range(insects.size() - 1, -1, -1):
		if float(insects[i].get("hit_cooldown", 0.0)) <= 0.0 and _distance_to_segment(insects[i]["position"], from, to) <= float(insects[i]["radius"]) + SPIDER_RADIUS:
			_try_hit_insect(i)


func _try_hit_insect(index: int) -> bool:
	if index < 0 or index >= insects.size():
		return false
	var insect := insects[index]
	var kind: String = insect["kind"]
	var speed := spider_velocity.length()
	var insect_direction: Vector2 = insect["velocity"].normalized()
	var approach := spider_velocity.normalized().dot(insect_direction)
	if kind == "moth" and speed < 520.0:
		spider_velocity *= 0.74
		insect["hit_cooldown"] = 0.3
		status_label.text = "MOTTE ABGESTREIFT · MEHR TEMPO"
		status_time = 1.0
		return false
	if kind == "beetle" and approach < 0.25 and bounces_this_flight == 0:
		spider_velocity = spider_velocity.bounce((spider_position - insect["position"]).normalized()) * 0.72
		bounces_this_flight += 1
		insect["hit_cooldown"] = 0.38
		status_label.text = "PANZER GEBLOCKT · VON HINTEN ODER NACH ABPRALLER"
		status_time = 1.2
		Input.vibrate_handheld(45)
		return false
	if kind == "wasp" and approach < -0.25:
		spider_velocity = -spider_velocity * 0.56
		hunger = maxf(0.0, hunger - 6.0)
		combo = 0
		insect["hit_cooldown"] = 0.42
		status_label.text = "FRONTALER STICH · HUNGER VERLOREN"
		status_time = 1.2
		Input.vibrate_handheld(75)
		return false
	_collect_insect(index)
	return true


func _collect_insect(index: int) -> void:
	if index < 0 or index >= insects.size():
		return
	var insect := insects[index]
	combo += 1
	best_combo = maxi(best_combo, combo)
	air_catches += 1
	score += int(insect["reward"]) * combo
	hunger = minf(100.0, hunger + float(insect["food"]))
	silk = minf(120.0, silk + float(insect["silk"]))
	status_label.text = "%s IM FLUG ERWISCHT · KOMBO x%d" % [_insect_name(insect["kind"]), combo]
	status_time = 1.1
	_create_burst(insect["position"], ORANGE)
	Input.vibrate_handheld(32)
	insects.remove_at(index)


func _insect_name(kind: String) -> String:
	return {"fly": "FLIEGE", "moth": "MOTTE", "wasp": "WESPE", "beetle": "PANZERKAEFER", "dragonfly": "LIBELLE"}.get(kind, "BEUTE")


func _finish_game(won: bool, reason: String) -> void:
	if game_finished:
		return
	game_finished = true
	aiming = false
	airborne = false
	result_overlay.visible = true
	result_title.text = "DU HAST ÜBERLEBT" if won else reason
	result_detail.text = "%d BEUTEPUNKTE\nBESTE KOMBO x%d · %d FÄDEN GEBAUT" % [score, best_combo, maxi(0, threads.size() - 1)]


func _go_to_menu() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _update_hud() -> void:
	var remaining := maxi(0, ceili(SURVIVAL_TIME - elapsed))
	survival_label.text = "ÜBERLEBE  %d:%02d" % [remaining / 60, remaining % 60]
	hunger_label.text = "HUNGER  %d %%" % roundi(hunger)
	hunger_label.add_theme_color_override("font_color", CORAL if hunger < 28.0 else ORANGE)
	silk_label.text = "SEIDE  %d" % roundi(silk)
	score_label.text = "BEUTE  %d" % score
	combo_label.text = "KOMBO x%d" % combo


func _draw() -> void:
	_draw_background()
	_draw_branches()
	_draw_threads()
	_draw_insects()
	_draw_particles()
	if aiming:
		_draw_aim()
	_draw_spider()


func _draw_background() -> void:
	var source_size := BACKGROUND.get_size()
	var crop_width := source_size.y * (DESIGN_SIZE.x / DESIGN_SIZE.y)
	var source_rect := Rect2(Vector2((source_size.x - crop_width) * 0.5, 0.0), Vector2(crop_width, source_size.y))
	draw_texture_rect_region(BACKGROUND, Rect2(Vector2.ZERO, DESIGN_SIZE), source_rect)
	draw_rect(Rect2(Vector2.ZERO, DESIGN_SIZE), Color(PINE, 0.2))


func _draw_branches() -> void:
	for anchor in branch_anchors:
		draw_circle(anchor, 13.0, Color(PINE, 0.42))
		if aiming or elapsed < 10.0:
			draw_arc(anchor, 24.0, 0.0, TAU, 24, Color(LICHEN, 0.44), 2.5, true)
		_draw_texture_centered(KNOT, anchor, 0.13, 0.0, Color(SILK_COLOR, 0.88))


func _draw_threads() -> void:
	for thread in threads:
		var health_ratio := clampf(float(thread["health"]) / 100.0, 0.0, 1.0)
		if health_ratio <= 0.0:
			continue
		var tint := Color(SILK_COLOR, (0.46 if bool(thread["fixed"]) else 0.86) * health_ratio)
		_draw_thread(thread["a"], thread["b"], tint, 25.0 if bool(thread["fixed"]) else 31.0)


func _draw_thread(a: Vector2, b: Vector2, tint: Color, height: float) -> void:
	var direction := b - a
	if direction.length() < 1.0:
		return
	draw_set_transform(a, direction.angle(), Vector2.ONE)
	draw_texture_rect(THREAD, Rect2(Vector2(0.0, -height * 0.5), Vector2(direction.length(), height)), false, tint)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_insects() -> void:
	for insect in insects:
		var texture := FLY
		var scale := 0.048
		if insect["kind"] == "moth":
			texture = MOTH
			scale = 0.064
		elif insect["kind"] == "wasp":
			texture = WASP
			scale = 0.072
			draw_circle(insect["position"], 48.0, Color(CORAL, 0.14))
		elif insect["kind"] == "beetle":
			texture = BEETLE
			scale = 0.085
			draw_arc(insect["position"], 43.0, 0.0, TAU, 20, Color(LICHEN, 0.28), 3.0, true)
		elif insect["kind"] == "dragonfly":
			texture = DRAGONFLY
			scale = 0.078
		_draw_texture_centered(texture, insect["position"], scale, insect["velocity"].angle() + PI * 0.5, Color.WHITE)


func _draw_spider() -> void:
	var rotation := spider_velocity.angle() + PI * 0.5 if airborne else 0.0
	if not airborne and support_thread >= 0 and support_thread < threads.size():
		rotation = (threads[support_thread]["b"] - threads[support_thread]["a"]).angle() + PI * 0.5
		if support_direction < 0.0:
			rotation += PI
	if aiming:
		var pull := spider_position - aim_pointer
		rotation = pull.angle() + PI * 0.5
	draw_circle(spider_position + Vector2(0, 18), 43.0, Color(PINE, 0.28))
	_draw_texture_centered(SPIDER, spider_position, 0.19, rotation, Color.WHITE)


func _draw_aim() -> void:
	var pull := (spider_position - aim_pointer).limit_length(MAX_PULL)
	var cost := _launch_cost(pull.length(), aim_hold_time)
	var aim_color := CORAL if cost > silk else ORANGE
	draw_line(spider_position, spider_position - pull, Color(aim_color, 0.72), 7.0, true)
	draw_circle(spider_position - pull, 22.0, Color(PINE, 0.8))
	draw_arc(spider_position - pull, 25.0, 0.0, TAU, 24, aim_color, 4.0, true)
	var simulated_position := spider_position
	var simulated_velocity := pull * LAUNCH_SCALE
	for step in range(1, 9):
		var dt := 0.085
		simulated_velocity.y += GRAVITY * dt
		simulated_position += simulated_velocity * dt
		var alpha := 0.82 - float(step) * 0.045
		draw_circle(simulated_position, 8.0 - float(step) * 0.22, Color(aim_color, alpha))
	if aim_hold_time > AIM_SLOW_TIME:
		var pressure := clampf((aim_hold_time - AIM_SLOW_TIME) / (AUTO_LAUNCH_TIME - AIM_SLOW_TIME), 0.0, 1.0)
		draw_arc(spider_position, 58.0, -PI * 0.5, -PI * 0.5 + TAU * pressure, 32, Color(CORAL, 0.85), 6.0, true)


func _create_burst(position: Vector2, color: Color) -> void:
	for i in range(8):
		particles.append({"position": position, "velocity": Vector2.from_angle(float(i) / 8.0 * TAU) * randf_range(55.0, 120.0), "life": 0.55, "color": color})


func _update_particles(delta: float) -> void:
	for i in range(particles.size() - 1, -1, -1):
		particles[i]["position"] += particles[i]["velocity"] * delta
		particles[i]["life"] = float(particles[i]["life"]) - delta
		if float(particles[i]["life"]) <= 0.0:
			particles.remove_at(i)


func _draw_particles() -> void:
	for particle in particles:
		draw_circle(particle["position"], 5.0, Color(particle["color"], clampf(float(particle["life"]) * 1.8, 0.0, 1.0)))


func _draw_texture_centered(texture: Texture2D, position: Vector2, scale: float, rotation: float, tint: Color) -> void:
	var size := texture.get_size()
	draw_set_transform(position, rotation, Vector2(scale, scale))
	draw_texture(texture, -size * 0.5, tint)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _segment_intersection(a: Vector2, b: Vector2, c: Vector2, d: Vector2) -> Dictionary:
	var r := b - a
	var s := d - c
	var denominator := r.cross(s)
	if absf(denominator) < 0.001:
		return {"hit": false}
	var t := (c - a).cross(s) / denominator
	var u := (c - a).cross(r) / denominator
	if t >= 0.0 and t <= 1.0 and u >= 0.0 and u <= 1.0:
		return {"hit": true, "t": t, "position": a + r * t}
	return {"hit": false}


func _segment_ratio(point: Vector2, a: Vector2, b: Vector2) -> float:
	var segment := b - a
	if segment.length_squared() < 0.001:
		return 0.0
	return clampf((point - a).dot(segment) / segment.length_squared(), 0.0, 1.0)


func _distance_to_segment(point: Vector2, a: Vector2, b: Vector2) -> float:
	return point.distance_to(a.lerp(b, _segment_ratio(point, a, b)))
