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
	game._open_upgrade()
	await create_timer(0.55).timeout
	RenderingServer.force_draw(false)
	var image := root.get_texture().get_image()
	assert(image.save_png("res://artifacts/upgrade-fadenschnitt-current.png") == OK)
	print("UPGRADE_VISUAL_CAPTURE_OK")
	quit(0)
