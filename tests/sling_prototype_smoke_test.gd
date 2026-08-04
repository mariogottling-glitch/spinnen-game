extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene: PackedScene = load("res://sling_prototype.tscn")
	var game := scene.instantiate()
	root.add_child(game)
	await process_frame
	assert(not game.airborne)
	assert(game.threads.size() == 1)
	assert(game.hunger > 99.0)
	var crawl_start: Vector2 = game.spider_position
	game._update_ground_movement(0.25)
	assert(game.spider_position.distance_to(crawl_start) > 20.0)
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
		"food": 9.0, "silk": 5.0, "phase": 0.0, "hit_threads": {},
		"hit_cooldown": 0.0, "dodged_this_aim": false
	})
	game.hunger = 50.0
	game._collect_insect(0)
	assert(game.score > 0)
	assert(game.combo == 1)
	assert(game.hunger > 50.0)
	var cheap_launch: float = game._launch_cost(180.0, 0.5)
	var delayed_launch: float = game._launch_cost(180.0, 2.5)
	assert(delayed_launch > cheap_launch)
	game._queue_wave()
	assert(not game.spawn_queue.is_empty())
	game._spawn_insect_kind("moth", 800.0, true)
	var moth_index: int = game.insects.size() - 1
	game.spider_velocity = Vector2(300.0, 0.0)
	assert(not game._try_hit_insect(moth_index))
	assert(game.insects.size() > moth_index)
	game.spider_velocity = Vector2(700.0, 0.0)
	game.insects[moth_index]["hit_cooldown"] = 0.0
	assert(game._try_hit_insect(moth_index))
	game._finish_game(true, "TEST")
	assert(game.game_finished)
	assert(game.result_overlay.visible)
	print("SLING_PROTOTYPE_SMOKE_TEST_OK")
	quit(0)
