extends Node2D

const DESIGN_SIZE := Vector2(1080.0, 1920.0)
const PLAY_RECT := Rect2(48.0, 300.0, 984.0, 1330.0)
const SURVIVAL_TIME := 90.0
const GRAVITY := 330.0
const MAX_PULL := 265.0
const MIN_PULL := 34.0
const LAUNCH_SCALE := 4.35
const RESCUE_COST := 18.0
const SPIDER_RADIUS := 34.0

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
var air_catches := 0

var hunger := 100.0
var silk := 100.0
var score := 0
var combo := 0
var best_combo := 0
var elapsed := 0.0
var spawn_timer := 0.0
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
	_add_thread(Vector2(82, 980), Vector2(998, 980), true)
	_add_thread(branch_anchors[1], branch_anchors[7], true)
	_add_thread(branch_anchors[10], branch_anchors[3], true)
	spider_position = Vector2(520, 980)
	spider_velocity = Vector2.ZERO
	launch_origin = spider_position
	airborne = false
	aiming = false
	flight_time = 0.0
	air_catches = 0
	hunger = 100.0
	silk = 100.0
	score = 0
	combo = 0
	best_combo = 0
	elapsed = 0.0
	spawn_timer = 0.0
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
	var world_delta := delta * (0.34 if aiming else 1.0)
	elapsed += world_delta
	spawn_timer += world_delta
	hunger = maxf(0.0, hunger - world_delta * (0.82 + elapsed * 0.0055))
	if status_time > 0.0:
		status_time = maxf(0.0, status_time - delta)
		if status_time <= 0.0 and not aiming:
			status_label.text = "HALTEN · ZIEHEN · LOSLASSEN"

	if spawn_timer >= _spawn_interval():
		spawn_timer = 0.0
		_spawn_insect()
	_update_insects(world_delta)
	_update_particles(world_delta)
	if airborne:
		_update_flight(world_delta)
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
	aim_pointer = pointer
	aim_cost = 0.0
	status_label.text = "ZIEHE GEGEN DIE FLUGRICHTUNG"


func _update_aim(pointer: Vector2) -> void:
	if not aiming:
		return
	var pull := spider_position - pointer
	if pull.length() > MAX_PULL:
		pointer = spider_position - pull.normalized() * MAX_PULL
	aim_pointer = pointer
	aim_cost = _launch_cost((spider_position - aim_pointer).length())
	status_label.text = "SPRUNGKOSTEN  %.0f SEIDE" % aim_cost


func _release_aim(pointer: Vector2) -> void:
	if not aiming:
		return
	_update_aim(pointer)
	var pull := spider_position - aim_pointer
	aiming = false
	if pull.length() < MIN_PULL:
		status_label.text = "WEITER ZURÜCKZIEHEN"
		status_time = 1.2
		return
	var cost := _launch_cost(pull.length())
	if silk + 0.01 < cost:
		status_label.text = "ZU WENIG SEIDE FÜR DIESEN SPRUNG"
		status_time = 1.5
		return
	silk -= cost
	launch_origin = spider_position
	spider_velocity = pull.limit_length(MAX_PULL) * LAUNCH_SCALE
	airborne = true
	flight_time = 0.0
	air_catches = 0
	status_label.text = "FLUGLINIE HALTEN"


func _launch_cost(pull_length: float) -> float:
	return 4.0 + clampf(pull_length, 0.0, MAX_PULL) / 29.0


func _update_flight(delta: float) -> void:
	flight_time += delta
	var previous := spider_position
	spider_velocity.y += GRAVITY * delta
	spider_position += spider_velocity * delta
	_collect_insects_on_path(previous, spider_position)
	if flight_time >= 0.15:
		var landing := _find_landing(previous, spider_position)
		if bool(landing.get("hit", false)):
			_land_at(landing["position"])
			return
	if spider_position.x < -100.0 or spider_position.x > 1180.0 or spider_position.y < 220.0 or spider_position.y > 1760.0:
		_rescue_or_fall()


func _find_landing(from: Vector2, to: Vector2) -> Dictionary:
	var best_t := 2.0
	var best_position := Vector2.ZERO
	for anchor in branch_anchors:
		if _distance_to_segment(anchor, from, to) <= 42.0:
			var t := _segment_ratio(anchor, from, to)
			if t < best_t:
				best_t = t
				best_position = anchor
	for thread in threads:
		if float(thread["health"]) <= 0.0:
			continue
		var intersection := _segment_intersection(from, to, thread["a"], thread["b"])
		if bool(intersection.get("hit", false)) and float(intersection["t"]) < best_t:
			best_t = intersection["t"]
			best_position = intersection["position"]
	return {"hit": best_t <= 1.0, "position": best_position}


func _land_at(position: Vector2) -> void:
	spider_position = position
	spider_velocity = Vector2.ZERO
	airborne = false
	if launch_origin.distance_to(position) >= 70.0:
		_add_thread(launch_origin, position, false)
	var landing_bonus := air_catches * maxi(1, combo)
	if landing_bonus > 0:
		score += landing_bonus
		status_label.text = "SICHER GELANDET · +%d FLUGBONUS" % landing_bonus
	else:
		status_label.text = "SICHER GELANDET · NEUER FADEN"
	status_time = 1.5
	air_catches = 0
	_create_burst(position, LICHEN)


func _rescue_or_fall() -> void:
	airborne = false
	spider_velocity = Vector2.ZERO
	air_catches = 0
	combo = 0
	if silk >= RESCUE_COST:
		silk -= RESCUE_COST
		hunger = maxf(0.0, hunger - 7.0)
		spider_position = launch_origin
		status_label.text = "RETTUNGSFADEN · -18 SEIDE · KOMBO VERLOREN"
		status_time = 2.0
		_create_burst(spider_position, CORAL)
	else:
		_finish_game(false, "ABGESTÜRZT")


func _add_thread(a: Vector2, b: Vector2, fixed: bool) -> void:
	if a.distance_to(b) < 45.0:
		return
	threads.append({"a": a, "b": b, "health": 100.0, "fixed": fixed})


func _spawn_interval() -> float:
	return clampf(2.35 - elapsed * 0.012, 1.18, 2.35)


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
		var previous: Vector2 = insect["position"]
		var velocity: Vector2 = insect["velocity"]
		if insect["kind"] == "moth":
			velocity.y += sin(elapsed * 4.0 + float(insect["phase"])) * 42.0 * delta
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
		if _distance_to_segment(insects[i]["position"], from, to) <= float(insects[i]["radius"]) + SPIDER_RADIUS:
			_collect_insect(i)


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
	insects.remove_at(index)


func _insect_name(kind: String) -> String:
	return {"fly": "FLIEGE", "moth": "MOTTE", "wasp": "WESPE"}.get(kind, "BEUTE")


func _finish_game(won: bool, reason: String) -> void:
	if game_finished:
		return
	game_finished = true
	aiming = false
	airborne = false
	result_overlay.visible = true
	result_title.text = "DU HAST ÜBERLEBT" if won else reason
	result_detail.text = "%d BEUTEPUNKTE\nBESTE KOMBO x%d · %d FÄDEN GEBAUT" % [score, best_combo, maxi(0, threads.size() - 3)]


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
		draw_circle(anchor, 20.0, Color(PINE, 0.48))
		draw_arc(anchor, 27.0, 0.0, TAU, 24, Color(LICHEN, 0.48), 3.0, true)
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
		_draw_texture_centered(texture, insect["position"], scale, insect["velocity"].angle() + PI * 0.5, Color.WHITE)


func _draw_spider() -> void:
	var rotation := spider_velocity.angle() + PI * 0.5 if airborne else 0.0
	if aiming:
		var pull := spider_position - aim_pointer
		rotation = pull.angle() + PI * 0.5
	draw_circle(spider_position + Vector2(0, 18), 43.0, Color(PINE, 0.28))
	_draw_texture_centered(SPIDER, spider_position, 0.19, rotation, Color.WHITE)


func _draw_aim() -> void:
	var pull := (spider_position - aim_pointer).limit_length(MAX_PULL)
	var cost := _launch_cost(pull.length())
	var aim_color := CORAL if cost > silk else ORANGE
	draw_line(spider_position, spider_position - pull, Color(aim_color, 0.72), 7.0, true)
	draw_circle(spider_position - pull, 22.0, Color(PINE, 0.8))
	draw_arc(spider_position - pull, 25.0, 0.0, TAU, 24, aim_color, 4.0, true)
	var simulated_position := spider_position
	var simulated_velocity := pull * LAUNCH_SCALE
	for step in range(1, 13):
		var dt := 0.085
		simulated_velocity.y += GRAVITY * dt
		simulated_position += simulated_velocity * dt
		var alpha := 0.82 - float(step) * 0.045
		draw_circle(simulated_position, 8.0 - float(step) * 0.22, Color(aim_color, alpha))


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
