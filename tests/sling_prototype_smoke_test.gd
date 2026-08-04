extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene: PackedScene = load("res://sling_prototype.tscn")
	var game := scene.instantiate()
	root.add_child(game)
	await process_frame
	assert(not game.airborne)
	assert(game.threads.size() == 3)
	assert(game.hunger > 99.0)
	var silk_before: float = game.silk
	game._begin_aim(game.spider_position)
	game._update_aim(game.spider_position + Vector2(-180.0, 90.0))
	game._release_aim(game.aim_pointer)
	assert(game.airborne)
	assert(game.silk < silk_before)
	var flight_steps := 0
	while game.airborne and flight_steps < 360:
		game._update_flight(1.0 / 120.0)
		flight_steps += 1
	assert(not game.airborne)
	assert(not game.game_finished)
	game.spider_position = Vector2(520, 980)
	var thread_count_before: int = game.threads.size()
	game._land_at(game.branch_anchors[3])
	assert(not game.airborne)
	assert(game.threads.size() == thread_count_before + 1)
	game.insects.append({
		"id": 99, "kind": "fly", "position": game.spider_position,
		"velocity": Vector2.ZERO, "radius": 26.0, "reward": 1,
		"food": 9.0, "silk": 5.0, "phase": 0.0, "hit_threads": {}
	})
	game.hunger = 50.0
	game._collect_insect(0)
	assert(game.score > 0)
	assert(game.combo == 1)
	assert(game.hunger > 50.0)
	game._finish_game(true, "TEST")
	assert(game.game_finished)
	assert(game.result_overlay.visible)
	print("SLING_PROTOTYPE_SMOKE_TEST_OK")
	quit(0)
