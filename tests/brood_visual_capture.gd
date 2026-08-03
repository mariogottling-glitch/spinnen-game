extends SceneTree


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var scene: PackedScene = load("res://main.tscn")
	var game := scene.instantiate()
	root.add_child(game)
	await process_frame
	game._start_game_from_menu()
	for edge in [Vector2i(0, 12), Vector2i(12, 1), Vector2i(12, 13), Vector2i(13, 2), Vector2i(13, 14), Vector2i(14, 15), Vector2i(15, 12)]:
		game.edges.append(edge)
		game.edge_health.append(100.0)
		game.edge_age.append(0.0)
	game._apply_upgrade_effect("brood_nest")
	game._apply_upgrade_effect("brood_nest")
	game._apply_upgrade_effect("swarm_instinct")
	game._apply_upgrade_effect("spider_queen")
	await create_timer(1.4).timeout
	RenderingServer.force_draw(false)
	var image := root.get_texture().get_image()
	var result := image.save_png("res://artifacts/brood-build-current.png")
	assert(result == OK)
	print("BROOD_VISUAL_CAPTURE_OK")
	quit(0)
