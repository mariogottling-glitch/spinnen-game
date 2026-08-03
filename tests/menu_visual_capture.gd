extends SceneTree


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var scene: PackedScene = load("res://main.tscn")
	var game := scene.instantiate()
	root.add_child(game)
	await process_frame
	await create_timer(0.7).timeout
	RenderingServer.force_draw(false)
	var image := root.get_texture().get_image()
	var result := image.save_png("res://artifacts/start-menu-current.png")
	assert(result == OK)
	print("MENU_VISUAL_CAPTURE_OK")
	quit(0)
