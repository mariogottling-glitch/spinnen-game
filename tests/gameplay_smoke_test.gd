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
	assert(game.THREAD_NATURAL_TEXTURE != null)
	assert(game.THREAD_REINFORCED_TEXTURE != null)
	assert(game.THREAD_STICKY_TEXTURE != null)
	assert(game.THREAD_KNOT_TEXTURE != null)
	assert(game.BEETLE_TEXTURE != null)
	assert(game.DRAGONFLY_TEXTURE != null)
	assert(game.FIREFLY_TEXTURE != null)
	assert(game.WASP_QUEEN_TEXTURE != null)
	assert(game.TITAN_BEETLE_TEXTURE != null)
	assert(game.RAZOR_HORNET_TEXTURE != null)

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
	assert(game.lure_button.button_down.is_connected(game._pluck_web))
	assert(game.contract_one.button_down.is_connected(game._choose_contract.bind(0)))
	game._toggle_reduced_motion()
	assert(game.reduced_motion)
	game.play_button.button_down.emit()
	assert(game.run_started)
	assert(not game.menu_open)
	assert(not game.start_menu.visible)
	assert(game.hud.visible)
	assert(game.contract_open)
	assert(game.contract_overlay.visible)
	assert(game.offered_contracts.size() == 3)
	var contract_ids := {}
	for contract in game.offered_contracts:
		contract_ids[contract["id"]] = true
	assert(contract_ids.size() == 3)
	game._choose_contract(0)
	assert(not game.contract_open)
	assert(not game.contract_overlay.visible)
	assert(not game.current_contract.is_empty())
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

	# All special prey types have distinct behavior and can enter the hunt pool.
	for special_kind in ["beetle", "dragonfly", "firefly"]:
		var special_spec: Dictionary = game._create_special_insect_spec(special_kind)
		assert(special_spec["kind"] == special_kind)
		assert(special_spec["special"])
	game.insects.clear()
	var dragonfly_spec: Dictionary = game._create_special_insect_spec("dragonfly")
	dragonfly_spec["from_left"] = true
	game._spawn_insect_from_spec(dragonfly_spec)
	game.insects[0]["position"] = Vector2(1200.0, 600.0)
	game.insects[0]["velocity"] = Vector2(300.0, 0.0)
	var passes_before: int = game.insects[0]["passes_left"]
	game._update_insects(0.01)
	assert(game.insects.size() == 1)
	assert(game.insects[0]["passes_left"] == passes_before - 1)
	game.insects.clear()

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

	# Living Web: closed geometry becomes an active trap and hubs repair the web.
	game._add_edge(0, 12)
	game._add_edge(12, 13)
	game._add_edge(13, 0)
	game._add_edge(0, 14)
	game._refresh_web_glyphs()
	var triangle_count := 0
	var heart_count := 0
	for glyph in game.web_glyphs:
		if glyph["type"] == "triangle":
			triangle_count += 1
		elif glyph["type"] == "heart":
			heart_count += 1
	assert(triangle_count >= 1)
	assert(heart_count >= 1)
	var triangle_center: Vector2 = (game.anchors[0] + game.anchors[12] + game.anchors[13]) / 3.0
	assert(not game._triangle_glyph_at(triangle_center).is_empty())
	game.vibration = 0.0
	game.lure_cooldown = 0.0
	game.flight_warnings.clear()
	game._pluck_web()
	assert(game.vibration >= 34.0)
	assert(game.flight_warnings.size() == 3)
	assert(game.lure_cooldown > 0.0)
	var insect_count_before_warning: int = game.insects.size()
	game._update_flight_warnings(3.0)
	assert(game.flight_warnings.is_empty())
	assert(game.insects.size() == insect_count_before_warning + 3)
	game.insects.clear()

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
	game.hunt_level = 2
	game._spawn_boss_moth()
	assert(game.insects[0]["kind"] == "titan_beetle")
	game.insects.clear()
	game.boss_active = false
	game.hunt_level = 3
	game._spawn_boss_moth()
	assert(game.insects[0]["kind"] == "razor_hornet")
	game.insects.clear()
	game.boss_active = false
	game.hunt_level = 1
	game._spawn_boss_moth()
	assert(game.boss_active)
	assert(game.insects.size() == 1)
	assert(game.insects[0]["boss"])
	assert(game.insects[0]["kind"] == "wasp_queen")
	game.insects[0]["caught"] = true
	game.insects[0]["edge"] = 0
	game.insects[0]["phase"] = 0.5
	var boss_hits_before_miss: int = game.insects[0]["boss_hits"]
	var edge_health_before_miss: float = game.edge_health[0]
	game._begin_bite_timing(game.insects[0]["id"])
	assert(game.bite_active)
	game.bite_progress = 0.0
	game.bite_target_center = 0.7
	game._resolve_bite_timing()
	assert(game.insects[0]["boss_hits"] == boss_hits_before_miss)
	assert(game.edge_health[0] < edge_health_before_miss)
	game.insects[0]["caught"] = true
	game.insects[0]["edge"] = 0
	game.insects[0]["phase"] = 0.5
	var xp_before_perfect: int = game.xp
	game._begin_bite_timing(game.insects[0]["id"])
	game.bite_progress = game.bite_target_center
	game._resolve_bite_timing()
	assert(game.xp == xp_before_perfect + 2)
	assert(game.insects[0]["boss_hits"] == boss_hits_before_miss - game.boss_damage - 1)
	game.insects[0]["caught"] = true
	game.insects[0]["edge"] = 0
	game.insects[0]["phase"] = 0.5
	game._begin_bite_timing(game.insects[0]["id"])
	game.bite_progress = game.bite_target_center
	game._resolve_bite_timing()
	assert(game.level_complete)
	assert(game.level_complete_overlay.visible)

	print("GAMEPLAY_SMOKE_TEST_OK")
	quit(0)
