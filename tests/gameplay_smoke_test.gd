extends SceneTree


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene: PackedScene = load("res://main.tscn")
	var game := scene.instantiate()
	root.add_child(game)
	await process_frame
	var upgrade_db = load("res://scripts/upgrade_database.gd")
	var all_upgrades: Array[Dictionary] = upgrade_db.all()
	assert(all_upgrades.size() == 29)
	var icon_keys := {}
	for upgrade in all_upgrades:
		assert(upgrade["icon"] == upgrade["id"])
		icon_keys[upgrade["icon"]] = true
	assert(icon_keys.size() == all_upgrades.size())
	assert(game.UPGRADE_ICON_TEXTURES.size() == all_upgrades.size())

	assert(game.menu_open)
	assert(game.start_menu.visible)
	assert(not game.hud.visible)
	assert(game.play_button.text == "JAGD BEGINNEN")
	assert(game.update_button.text == "UPDATE")
	assert(game.ANDROID_UPDATE_URL.ends_with("/releases/latest/download/web-weaver-android.apk?download=1"))
	assert(game.play_button.button_down.is_connected(game._start_game_from_menu))
	assert(game.how_to_button.button_down.is_connected(game._show_how_to))
	assert(game.settings_button.button_down.is_connected(game._show_settings))
	assert(game.update_button.button_down.is_connected(game._open_android_update))
	game._toggle_reduced_motion()
	assert(game.reduced_motion)
	game.play_button.button_down.emit()
	assert(game.run_started)
	assert(not game.menu_open)
	assert(not game.start_menu.visible)
	assert(game.hud.visible)
	game._open_main_menu()
	assert(game.menu_open)
	assert(not game.hud.visible)
	assert(game.play_button.text == "WEITERSPIELEN")
	game.how_to_button.button_down.emit()
	assert(game.how_to_overlay.visible)
	game._close_menu_panel()
	assert(not game.how_to_overlay.visible)
	game.settings_button.button_down.emit()
	assert(game.settings_overlay.visible)
	game._close_menu_panel()
	assert(not game.settings_overlay.visible)
	game._start_game_from_menu()
	assert(not game.menu_open)

	game._apply_upgrade_effect("armored_knots")
	game._add_edge(0, 1)
	assert(game.edge_health[0] > game.thread_strength)
	game._apply_upgrade_effect("emergency_patch")
	game.edge_health[0] = 0.0
	game._update_threads(0.1)
	assert(game.edge_health[0] > 0.0)
	game._apply_upgrade_effect("dew_trap")
	assert(game.gnat_reward_level == 1)
	game._apply_upgrade_effect("predator_focus")
	assert(game.active_catch_multiplier > 1.0)
	game._apply_upgrade_effect("silk_dash")
	assert(game.pounce_repair_amount > 0.0)
	game._apply_upgrade_effect("emergency_reserve")
	game.silk = 0.0
	game._try_emergency_reserve()
	assert(game.silk >= 35.0)
	game._apply_upgrade_effect("rich_cocoon")
	assert(game.boss_reward_multiplier > 1.0)
	game._apply_upgrade_effect("brood_nest")
	assert(game.helper_spiders.size() == 1)
	var speed_before_swarm: float = game.spider_speed
	game._apply_upgrade_effect("swarm_instinct")
	assert(game.helper_spiders.size() == 2)
	assert(game.spider_speed > speed_before_swarm)
	game._apply_upgrade_effect("silk_menders")
	game.edge_health[0] = 10.0
	game._perform_helper_action()
	assert(game.edge_health[0] > 10.0)
	game._apply_upgrade_effect("young_hunters")
	game.insects.clear()
	game._spawn_insect()
	game.insects[0]["caught"] = true
	game.insects[0]["auto_collect"] = false
	game.insects[0]["boss"] = false
	game._perform_helper_action()
	assert(game.insects.is_empty())
	game._apply_upgrade_effect("spider_queen")
	assert(game.helper_spiders.size() == 4)

	game.insects.clear()
	game._spawn_insect()
	game._spawn_insect()
	for insect in game.insects:
		insect["caught"] = true
		insect["auto_collect"] = false
		insect["boss"] = false
	game.chain_capture_chance = 1.0
	game._collect_insect(0)
	assert(game.insects.is_empty())

	game._open_upgrade()
	assert(game.upgrade_open)
	assert(game.offered_upgrades.size() == 3)
	var offered_ids := {}
	for upgrade in game.offered_upgrades:
		offered_ids[upgrade["id"]] = true
	assert(offered_ids.size() == 3)

	game.upgrade_open = false
	game.upgrade_overlay.visible = false
	game._spawn_boss_moth()
	assert(game.boss_active)
	assert(game.insects.size() == 1)
	assert(game.insects[0]["boss"])
	game._collect_insect(0)
	assert(game.level_complete)
	assert(game.level_complete_overlay.visible)

	print("GAMEPLAY_SMOKE_TEST_OK")
	quit(0)
