extends SceneTree


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var scene: PackedScene = load("res://main.tscn")
	var game := scene.instantiate()
	root.add_child(game)
	await process_frame
	game._start_game_from_menu()
	game._choose_contract(0)
	for edge in [Vector2i(0, 12), Vector2i(12, 1), Vector2i(12, 13), Vector2i(13, 2), Vector2i(13, 14), Vector2i(14, 15), Vector2i(15, 12)]:
		game.edges.append(edge)
		game.edge_health.append(100.0)
		game.edge_age.append(0.0)
	game._spawn_wasp_miniboss()
	var wasp: Dictionary = game.insects[0]
	wasp["caught"] = true
	wasp["edge"] = 4
	wasp["phase"] = 0.5
	wasp["position"] = game.anchors[game.edges[4].x].lerp(game.anchors[game.edges[4].y], 0.5)
	game.spider_position = wasp["position"]
	game._begin_bite_timing(wasp["id"])
	game.bite_target_center = 0.64
	game.bite_progress = 0.57
	game.set_process(false)
	game.queue_redraw()
	await process_frame
	RenderingServer.force_draw(false)
	var image := root.get_texture().get_image()
	var result := image.save_png("res://artifacts/wasp-bite-current.png")
	assert(result == OK)
	print("WASP_VISUAL_CAPTURE_OK")
	quit(0)
