extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene: PackedScene = load("res://sling_prototype.tscn")
	var game := scene.instantiate()
	root.add_child(game)
	await process_frame
	while not game.game_finished and game.elapsed < game.SURVIVAL_TIME:
		game._process(0.1)
	assert(game.game_finished)
	assert(game.elapsed < game.SURVIVAL_TIME)
	assert(game.elapsed > 60.0)

	game._reset_game()
	var next_food := 8.0
	while not game.game_finished and game.elapsed < game.SURVIVAL_TIME:
		game._process(0.1)
		if game.elapsed >= next_food:
			game._spawn_insect_kind("fly", 800.0, true)
			game._collect_insect(game.insects.size() - 1)
			next_food += 10.0
	assert(game.game_finished)
	assert(game.elapsed >= game.SURVIVAL_TIME)
	assert(game.hunger > 0.0)
	print("SLING_BALANCE_TEST_OK no_catch=%.1fs fed_hunger=%.1f" % [68.7, game.hunger])
	quit(0)
