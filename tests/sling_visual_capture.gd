extends SceneTree


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var scene: PackedScene = load("res://sling_prototype.tscn")
	var game := scene.instantiate()
	root.add_child(game)
	await process_frame
	game.elapsed = 36.0
	game._spawn_insect()
	game._spawn_insect()
	game.insects[0]["position"] = Vector2(720, 720)
	game.insects[1]["position"] = Vector2(330, 1260)
	game._begin_aim(game.spider_position)
	game._update_aim(game.spider_position + Vector2(-210, 105))
	game._update_hud()
	game.queue_redraw()
	await create_timer(0.35).timeout
	RenderingServer.force_draw(false)
	var image := root.get_texture().get_image()
	assert(image.save_png("res://artifacts/sling-prototype-current.png") == OK)
	print("SLING_VISUAL_CAPTURE_OK")
	quit(0)
