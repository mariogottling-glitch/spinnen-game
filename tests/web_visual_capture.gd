extends SceneTree


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var scene: PackedScene = load("res://main.tscn")
	var game := scene.instantiate()
	root.add_child(game)
	await process_frame
	game._start_game_from_menu()
	await process_frame
	RenderingServer.force_draw(false)
	var contract_image := root.get_texture().get_image()
	assert(contract_image.save_png("res://artifacts/contract-selection-current.png") == OK)
	game._choose_contract(0)
	for edge in [Vector2i(0, 12), Vector2i(12, 1), Vector2i(12, 13), Vector2i(13, 0), Vector2i(13, 2), Vector2i(13, 14), Vector2i(14, 15), Vector2i(15, 12), Vector2i(15, 10)]:
		game.edges.append(edge)
		game.edge_health.append(100.0)
		game.edge_age.append(0.0)
	game._refresh_web_glyphs()
	game.vibration = 58.0
	game.flight_warnings.clear()
	game._queue_insect_warning(true)
	game._queue_insect_warning(true, 0.35)
	game._update_hud()
	game.queue_redraw()
	await process_frame
	RenderingServer.force_draw(false)
	var normal_image := root.get_texture().get_image()
	assert(normal_image.save_png("res://artifacts/web-natural-current.png") == OK)
	game.flight_warnings.clear()
	game.insects.clear()
	var special_positions := [Vector2(280.0, 720.0), Vector2(540.0, 860.0), Vector2(800.0, 720.0)]
	var special_kinds := ["beetle", "dragonfly", "firefly"]
	for i in range(special_kinds.size()):
		var spec: Dictionary = game._create_special_insect_spec(special_kinds[i])
		game._spawn_insect_from_spec(spec)
		game.insects[i]["position"] = special_positions[i]
		game.insects[i]["velocity"] = Vector2.ZERO
	game.queue_redraw()
	await process_frame
	RenderingServer.force_draw(false)
	var special_image := root.get_texture().get_image()
	assert(special_image.save_png("res://artifacts/special-prey-current.png") == OK)
	game.insects.clear()
	game._apply_upgrade_effect("strong_silk")
	game._apply_upgrade_effect("sticky_web")
	game._apply_upgrade_effect("sticky_web")
	game.queue_redraw()
	await process_frame
	RenderingServer.force_draw(false)
	var upgraded_image := root.get_texture().get_image()
	assert(upgraded_image.save_png("res://artifacts/web-upgraded-current.png") == OK)
	print("WEB_VISUAL_CAPTURE_OK")
	quit(0)
