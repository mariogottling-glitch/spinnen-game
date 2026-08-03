class_name FadenschnittTheme
extends RefCounted

const PINE := Color("#102A24")
const MOSS := Color("#315A45")
const LICHEN := Color("#A7C46A")
const SILK := Color("#F2E8D5")
const ORANGE := Color("#F28C28")
const CORAL := Color("#E3564A")

const DISPLAY_FONT: Font = preload("res://assets/fonts/BarlowCondensed-SemiBold.ttf")
const BODY_FONT: Font = preload("res://assets/fonts/Barlow-Medium.ttf")
const MENU_BACKGROUND: Texture2D = preload("res://assets/backgrounds/main-menu-fadenschnitt-v1.png")
const GAME_BACKGROUND: Texture2D = preload("res://assets/backgrounds/forest-fadenschnitt-v1.png")
const CONTRACT_BEETLE: Texture2D = preload("res://assets/ui/contracts/beetle-fadenschnitt-v1.png")
const CONTRACT_DRAGONFLY: Texture2D = preload("res://assets/ui/contracts/dragonfly-fadenschnitt-v1.png")
const CONTRACT_FIREFLY: Texture2D = preload("res://assets/ui/contracts/firefly-fadenschnitt-v1.png")
const THREAD_OVERLAY: Texture2D = preload("res://assets/ui/fadenschnitt-thread-overlay-v1.png")
const PALETTE_SHADER: Shader = preload("res://assets/shaders/fadenschnitt_palette.gdshader")


static func apply(root: Node) -> void:
	_apply_fonts(root)
	_apply_world_palette(root)
	_apply_hud(root)
	_apply_start_menu(root)
	_apply_contracts(root)
	_apply_upgrades(root)
	_apply_secondary_overlays(root)


static func contract_portrait(kind: String) -> Texture2D:
	match kind:
		"dragonfly":
			return CONTRACT_DRAGONFLY
		"firefly":
			return CONTRACT_FIREFLY
		_:
			return CONTRACT_BEETLE


static func _apply_fonts(node: Node) -> void:
	if node is Control:
		(node as Control).add_theme_font_override("font", BODY_FONT)
	for child in node.get_children():
		_apply_fonts(child)


static func _apply_world_palette(root: Node) -> void:
	if root is CanvasItem:
		var world_material := ShaderMaterial.new()
		world_material.shader = PALETTE_SHADER
		world_material.set_shader_parameter("palette_strength", 0.38)
		(root as CanvasItem).material = world_material


static func _apply_hud(root: Node) -> void:
	var top_panel := root.get_node("HUD/TopPanel") as Panel
	top_panel.add_theme_stylebox_override("panel", _box(Color(PINE, 0.94), SILK, 2, 10, ORANGE, 8))
	var hint_panel := root.get_node("HUD/HintBackdrop") as Panel
	hint_panel.add_theme_stylebox_override("panel", _box(Color(PINE, 0.94), SILK, 2, 10))
	for path in ["HUD/Title", "HUD/HuntGoal", "HUD/BuildSummary", "HUD/Threads"]:
		var label := root.get_node(path) as Label
		label.add_theme_font_override("font", DISPLAY_FONT)
	(root.get_node("HUD/Title") as Label).add_theme_color_override("font_color", SILK)
	(root.get_node("HUD/Integrity") as Label).add_theme_color_override("font_color", LICHEN)
	(root.get_node("HUD/SilkLabel") as Label).add_theme_color_override("font_color", ORANGE)
	(root.get_node("HUD/XPLabel") as Label).add_theme_color_override("font_color", LICHEN)
	(root.get_node("HUD/HuntGoal") as Label).add_theme_color_override("font_color", ORANGE)
	(root.get_node("HUD/VibrationLabel") as Label).add_theme_color_override("font_color", CORAL)
	(root.get_node("HUD/GlyphSummary") as Label).add_theme_color_override("font_color", LICHEN)
	_apply_progress(root.get_node("HUD/SilkBar") as ProgressBar, ORANGE)
	_apply_progress(root.get_node("HUD/XPBar") as ProgressBar, LICHEN)
	_apply_progress(root.get_node("HUD/VibrationBar") as ProgressBar, CORAL)
	for path in ["HUD/MenuButton", "HUD/LureButton"]:
		var button := root.get_node(path) as Button
		button.focus_mode = Control.FOCUS_NONE
		button.add_theme_font_override("font", DISPLAY_FONT)
		button.add_theme_color_override("font_color", SILK)
		button.add_theme_stylebox_override("normal", _box(Color(PINE, 0.92), SILK, 2, 8))
		button.add_theme_stylebox_override("hover", _box(MOSS, LICHEN, 3, 8))
		button.add_theme_stylebox_override("pressed", _box(ORANGE, SILK, 2, 8))


static func _apply_start_menu(root: Node) -> void:
	var art := root.get_node("StartMenu/MenuArt") as TextureRect
	art.texture = MENU_BACKGROUND
	(root.get_node("StartMenu/Scrim") as ColorRect).color = Color(PINE, 0.08)
	for path in ["StartMenu/PrototypeBadge", "StartMenu/HeroSpider", "StartMenu/MenuCard/CardHeading", "StartMenu/MenuCard/Stats"]:
		(root.get_node(path) as CanvasItem).visible = false

	var title := root.get_node("StartMenu/Title") as Label
	title.visible = true
	title.position = Vector2(82, 690)
	title.size = Vector2(916, 250)
	title.text = "WEB\nWEAVER"
	title.add_theme_font_override("font", DISPLAY_FONT)
	title.add_theme_font_size_override("font_size", 108)
	title.add_theme_constant_override("line_spacing", -24)
	title.add_theme_color_override("font_color", SILK)
	title.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)
	title.add_theme_color_override("font_outline_color", Color.TRANSPARENT)

	var subtitle := root.get_node("StartMenu/Subtitle") as Label
	subtitle.visible = true
	subtitle.position = Vector2(140, 948)
	subtitle.size = Vector2(800, 76)
	subtitle.text = "BAUE.  LOCKE.  SCHLAGE ZU."
	subtitle.add_theme_font_override("font", DISPLAY_FONT)
	subtitle.add_theme_font_size_override("font_size", 30)
	subtitle.add_theme_color_override("font_color", LICHEN)

	var play := root.get_node("StartMenu/MenuCard/PlayButton") as Button
	_style_menu_button(play, Vector2(105, 1120), Vector2(870, 150), true)
	var how_to := root.get_node("StartMenu/MenuCard/HowToButton") as Button
	_style_menu_button(how_to, Vector2(105, 1310), Vector2(410, 118), false)
	var settings := root.get_node("StartMenu/MenuCard/SettingsButton") as Button
	_style_menu_button(settings, Vector2(565, 1310), Vector2(410, 118), false)
	var update := root.get_node("StartMenu/MenuCard/UpdateButton") as Button
	_style_menu_button(update, Vector2(790, 70), Vector2(220, 78), false)
	update.add_theme_font_size_override("font_size", 24)
	update.text = "UPDATE LADEN"

	var version := root.get_node("StartMenu/Version") as Label
	version.position = Vector2(240, 1775)
	version.size = Vector2(600, 40)
	version.add_theme_font_override("font", DISPLAY_FONT)
	version.add_theme_color_override("font_color", Color(SILK, 0.56))
	version.text = "VERSION 0.12.0-test.2  ·  FADENSCHNITT"


static func _style_menu_button(button: Button, position: Vector2, size: Vector2, primary: bool) -> void:
	button.position = position
	button.size = size
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_override("font", DISPLAY_FONT)
	button.add_theme_font_size_override("font_size", 38 if primary else 27)
	button.add_theme_color_override("font_color", PINE if primary else SILK)
	button.add_theme_color_override("font_hover_color", PINE if primary else SILK)
	button.add_theme_color_override("font_pressed_color", SILK)
	var normal_background := SILK if primary else Color(PINE, 0.93)
	var normal_border := ORANGE if primary else SILK
	button.add_theme_stylebox_override("normal", _box(normal_background, normal_border, 4 if primary else 2, 10, PINE, 10 if primary else 4))
	button.add_theme_stylebox_override("hover", _box(LICHEN if primary else MOSS, SILK, 4, 10, PINE, 8))
	button.add_theme_stylebox_override("pressed", _box(ORANGE, SILK, 4, 10))


static func _apply_contracts(root: Node) -> void:
	var overlay := root.get_node("HUD/ContractOverlay") as ColorRect
	overlay.color = PINE
	_add_overlay_art(overlay, 0.34, 0.18)
	var level_caption := root.get_node("HUD/ContractOverlay/LevelCaption") as Label
	level_caption.position = Vector2(70, 110)
	level_caption.size = Vector2(940, 52)
	level_caption.add_theme_font_override("font", DISPLAY_FONT)
	level_caption.add_theme_font_size_override("font_size", 28)
	level_caption.add_theme_color_override("font_color", LICHEN)
	var heading := root.get_node("HUD/ContractOverlay/Heading") as Label
	heading.position = Vector2(70, 165)
	heading.size = Vector2(940, 100)
	heading.text = "JAGDVERTRÄGE"
	heading.add_theme_font_override("font", DISPLAY_FONT)
	heading.add_theme_font_size_override("font_size", 72)
	heading.add_theme_color_override("font_color", SILK)
	heading.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)
	var subheading := root.get_node("HUD/ContractOverlay/Subheading") as Label
	subheading.position = Vector2(130, 270)
	subheading.size = Vector2(820, 56)
	subheading.text = "WÄHLE DEIN RISIKO"
	subheading.add_theme_font_override("font", DISPLAY_FONT)
	subheading.add_theme_font_size_override("font_size", 29)
	subheading.add_theme_color_override("font_color", LICHEN)

	var cards: Array[Button] = [
		root.get_node("HUD/ContractOverlay/ContractOne") as Button,
		root.get_node("HUD/ContractOverlay/ContractTwo") as Button,
		root.get_node("HUD/ContractOverlay/ContractThree") as Button,
	]
	var card_positions := [Vector2(60, 385), Vector2(82, 742), Vector2(60, 1099)]
	for i in range(cards.size()):
		_style_contract_card(cards[i], card_positions[i], i == 1)

	var footer := root.get_node("HUD/ContractOverlay/Footer") as Label
	footer.position = Vector2(110, 1490)
	footer.size = Vector2(860, 86)
	footer.text = "ANTIPPEN ZUM ANNEHMEN"
	footer.add_theme_font_override("font", DISPLAY_FONT)
	footer.add_theme_font_size_override("font_size", 26)
	footer.add_theme_color_override("font_color", LICHEN)


static func _style_contract_card(card: Button, position: Vector2, light: bool) -> void:
	card.position = position
	card.size = Vector2(938 if light else 960, 320)
	card.rotation = 0.0
	card.pivot_offset = card.size * 0.5
	card.focus_mode = Control.FOCUS_NONE
	var foreground := PINE if light else SILK
	var background := SILK if light else MOSS
	card.add_theme_stylebox_override("normal", _box(background, SILK if not light else LICHEN, 3, 9, Color(PINE, 0.75), 10))
	card.add_theme_stylebox_override("hover", _box(background, ORANGE, 6, 9, Color(PINE, 0.75), 8))
	card.add_theme_stylebox_override("pressed", _box(ORANGE, SILK, 5, 9))
	var sigil := card.get_node("Sigil") as Label
	sigil.visible = false
	var portrait := card.get_node_or_null("Portrait") as TextureRect
	if portrait == null:
		portrait = TextureRect.new()
		portrait.name = "Portrait"
		portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		card.add_child(portrait)
	portrait.position = Vector2(20, 18)
	portrait.size = Vector2(280, 284)
	portrait.show_behind_parent = false

	var title := card.get_node("Title") as Label
	title.position = Vector2(320, 30)
	title.size = Vector2(580, 74)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", DISPLAY_FONT)
	title.add_theme_font_size_override("font_size", 40)
	title.add_theme_color_override("font_color", foreground)
	var risk := card.get_node("Risk") as Label
	risk.position = Vector2(320, 112)
	risk.size = Vector2(580, 70)
	risk.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	risk.add_theme_font_override("font", DISPLAY_FONT)
	risk.add_theme_font_size_override("font_size", 27)
	risk.add_theme_color_override("font_color", CORAL)
	var reward := card.get_node("Reward") as Label
	reward.position = Vector2(320, 182)
	reward.size = Vector2(580, 62)
	reward.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	reward.add_theme_font_override("font", DISPLAY_FONT)
	reward.add_theme_font_size_override("font_size", 29)
	reward.add_theme_color_override("font_color", LICHEN if not light else MOSS)
	var special := card.get_node("Special") as Label
	special.position = Vector2(320, 250)
	special.size = Vector2(580, 45)
	special.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	special.add_theme_font_override("font", DISPLAY_FONT)
	special.add_theme_font_size_override("font_size", 22)
	special.add_theme_color_override("font_color", Color(foreground, 0.78))


static func _apply_upgrades(root: Node) -> void:
	var overlay := root.get_node("HUD/UpgradeOverlay") as ColorRect
	overlay.color = PINE
	_add_overlay_art(overlay, 0.26, 0.09)
	var caption := root.get_node("HUD/UpgradeOverlay/LevelCaption") as Label
	caption.add_theme_font_override("font", DISPLAY_FONT)
	caption.add_theme_color_override("font_color", LICHEN)
	var heading := root.get_node("HUD/UpgradeOverlay/Heading") as Label
	heading.add_theme_font_override("font", DISPLAY_FONT)
	heading.add_theme_color_override("font_color", SILK)
	heading.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)
	var icon_material := ShaderMaterial.new()
	icon_material.shader = PALETTE_SHADER
	icon_material.set_shader_parameter("palette_strength", 1.0)
	var cards: Array[Button] = [
		root.get_node("HUD/UpgradeOverlay/UpgradeOne") as Button,
		root.get_node("HUD/UpgradeOverlay/UpgradeTwo") as Button,
		root.get_node("HUD/UpgradeOverlay/UpgradeThree") as Button,
	]
	for i in range(cards.size()):
		_style_upgrade_card(cards[i], i == 1, icon_material)


static func _style_upgrade_card(card: Button, light: bool, icon_material: ShaderMaterial) -> void:
	card.rotation = 0.0
	card.focus_mode = Control.FOCUS_NONE
	card.add_theme_stylebox_override("normal", _box(SILK if light else MOSS, LICHEN if light else SILK, 3, 9, Color(PINE, 0.76), 12))
	card.add_theme_stylebox_override("hover", _box(SILK if light else MOSS, ORANGE, 6, 9, Color(PINE, 0.72), 10))
	card.add_theme_stylebox_override("pressed", _box(ORANGE, SILK, 5, 9))
	var foreground := PINE if light else SILK
	for node_name in ["Rarity", "Title", "Value", "Description"]:
		var label := card.get_node(node_name) as Label
		label.add_theme_font_override("font", DISPLAY_FONT if node_name != "Description" else BODY_FONT)
		label.add_theme_color_override("font_color", foreground)
	(card.get_node("Icon") as TextureRect).material = icon_material
	var divider := card.get_node("Divider") as ColorRect
	divider.color = Color(LICHEN, 0.75)
	var ribbon := card.get_node("Ribbon") as Panel
	ribbon.add_theme_stylebox_override("panel", _box(PINE if light else Color(PINE, 0.88), Color.TRANSPARENT, 0, 0))
	var ribbon_label := card.get_node("Ribbon/Label") as Label
	ribbon_label.add_theme_font_override("font", DISPLAY_FONT)
	ribbon_label.add_theme_color_override("font_color", LICHEN)


static func _apply_secondary_overlays(root: Node) -> void:
	for overlay_path in ["StartMenu/HowToOverlay", "StartMenu/SettingsOverlay"]:
		(root.get_node(overlay_path) as ColorRect).color = Color(PINE, 0.98)
	var panels: Array[Panel] = [
		root.get_node("StartMenu/HowToOverlay/Panel") as Panel,
		root.get_node("StartMenu/SettingsOverlay/Panel") as Panel,
	]
	for panel in panels:
		panel.add_theme_stylebox_override("panel", _box(MOSS, SILK, 3, 10, Color(PINE, 0.8), 12))
		var overlay_title := panel.get_node("Title") as Label
		overlay_title.add_theme_font_override("font", DISPLAY_FONT)
		overlay_title.add_theme_color_override("font_color", SILK)
	for path in ["StartMenu/HowToOverlay/Panel/BackButton", "StartMenu/SettingsOverlay/Panel/MotionButton", "StartMenu/SettingsOverlay/Panel/ResetButton", "StartMenu/SettingsOverlay/Panel/BackButton"]:
		var button := root.get_node(path) as Button
		button.focus_mode = Control.FOCUS_NONE
		button.add_theme_font_override("font", DISPLAY_FONT)
		button.add_theme_color_override("font_color", PINE)
		button.add_theme_stylebox_override("normal", _box(SILK, ORANGE, 3, 8))
		button.add_theme_stylebox_override("hover", _box(LICHEN, SILK, 3, 8))
		button.add_theme_stylebox_override("pressed", _box(ORANGE, SILK, 3, 8))
	var complete := root.get_node("HUD/LevelCompleteOverlay") as ColorRect
	complete.color = Color(PINE, 0.96)
	var complete_title := root.get_node("HUD/LevelCompleteOverlay/Title") as Label
	complete_title.add_theme_font_override("font", DISPLAY_FONT)
	complete_title.add_theme_color_override("font_color", ORANGE)
	complete_title.add_theme_color_override("font_shadow_color", Color.TRANSPARENT)


static func _apply_progress(progress: ProgressBar, fill_color: Color) -> void:
	progress.add_theme_stylebox_override("background", _box(Color(PINE, 0.92), Color.TRANSPARENT, 0, 3))
	progress.add_theme_stylebox_override("fill", _box(fill_color, Color.TRANSPARENT, 0, 3))


static func _add_overlay_art(overlay: Control, background_alpha: float, thread_alpha: float) -> void:
	var background := TextureRect.new()
	background.name = "FadenschnittBackground"
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.texture = GAME_BACKGROUND
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.modulate = Color(1.0, 1.0, 1.0, background_alpha)
	background.z_index = 0
	overlay.add_child(background)
	overlay.move_child(background, 0)

	var thread := TextureRect.new()
	thread.name = "FadenschnittThread"
	thread.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	thread.mouse_filter = Control.MOUSE_FILTER_IGNORE
	thread.texture = THREAD_OVERLAY
	thread.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	thread.stretch_mode = TextureRect.STRETCH_SCALE
	thread.position = Vector2(170, 0)
	thread.modulate = Color(1.0, 1.0, 1.0, thread_alpha)
	thread.z_index = 10
	overlay.add_child(thread)

static func _box(
	background: Color,
	border: Color = Color.TRANSPARENT,
	border_width: int = 0,
	radius: int = 8,
	shadow_color: Color = Color.TRANSPARENT,
	shadow_size: int = 0
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.border_width_left = border_width
	style.border_width_top = border_width
	style.border_width_right = border_width
	style.border_width_bottom = border_width
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_right = radius
	style.corner_radius_bottom_left = radius
	style.shadow_color = shadow_color
	style.shadow_size = shadow_size
	style.shadow_offset = Vector2(7, 9) if shadow_size > 0 else Vector2.ZERO
	return style
