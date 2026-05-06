extends Control

const SAVE_PATH := "user://save.json"

const PRODUCT_DEFS := {
	"milk": {"label": "SÜT", "color": Color("#dbeafe")},
	"juice": {"label": "MEYVE", "color": Color("#fed7aa")},
	"chips": {"label": "CİPS", "color": Color("#fef3c7")},
	"choco": {"label": "ÇİKO", "color": Color("#fde68a")},
	"detergent": {"label": "DETER", "color": Color("#bfdbfe")},
	"shampoo": {"label": "ŞAMP", "color": Color("#e9d5ff")},
	"soap": {"label": "SABUN", "color": Color("#bbf7d0")},
	"toy": {"label": "OYUN", "color": Color("#fecaca")},
	"apple": {"label": "ELMA", "color": Color("#fecdd3")},
	"banana": {"label": "MUZ", "color": Color("#fef08a")},
	"water": {"label": "SU", "color": Color("#bae6fd")},
	"coffee": {"label": "KAHVE", "color": Color("#d6d3d1")}
}

var levels: Array = []
var current_level_index: int = 0
var coins: int = 0
var max_slots: int = 7
var selected_slots: Array = []
var product_buttons: Array[Button] = []
var remaining_products: int = 0

var root_margin: MarginContainer
var main_box: VBoxContainer
var menu_panel: VBoxContainer
var game_panel: VBoxContainer
var shelves_container: VBoxContainer
var slots_container: HBoxContainer
var status_label: Label
var level_label: Label
var coins_label: Label
var slot_label: Label

func _ready() -> void:
	load_levels()
	load_save()
	build_ui()
	show_menu()

func load_levels() -> void:
	var file := FileAccess.open("res://data/levels.json", FileAccess.READ)
	if file == null:
		levels = []
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_ARRAY:
		levels = parsed
	else:
		levels = []

func load_save() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		current_level_index = 0
		coins = 0
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY:
		current_level_index = int(parsed.get("level", 0))
		coins = int(parsed.get("coins", 0))

func save_game() -> void:
	var data := {"level": current_level_index, "coins": coins}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(data))

func build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#f8fafc")
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	root_margin = MarginContainer.new()
	root_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	root_margin.add_theme_constant_override("margin_left", 26)
	root_margin.add_theme_constant_override("margin_right", 26)
	root_margin.add_theme_constant_override("margin_top", 28)
	root_margin.add_theme_constant_override("margin_bottom", 28)
	add_child(root_margin)

	main_box = VBoxContainer.new()
	main_box.add_theme_constant_override("separation", 16)
	root_margin.add_child(main_box)

	menu_panel = VBoxContainer.new()
	menu_panel.add_theme_constant_override("separation", 18)
	main_box.add_child(menu_panel)

	game_panel = VBoxContainer.new()
	game_panel.add_theme_constant_override("separation", 14)
	main_box.add_child(game_panel)

	build_menu_panel()
	build_game_panel()

func build_menu_panel() -> void:
	clear_children(menu_panel)

	var spacer_top := Control.new()
	spacer_top.custom_minimum_size = Vector2(1, 120)
	menu_panel.add_child(spacer_top)

	var title := Label.new()
	title.text = "Raf Ustası Mini"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color("#0f172a"))
	menu_panel.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "3 aynı ürünü eşleştir, rafları temizle."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 24)
	subtitle.add_theme_color_override("font_color", Color("#64748b"))
	menu_panel.add_child(subtitle)

	var coin_text := Label.new()
	coin_text.text = "Coin: %d" % coins
	coin_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	coin_text.add_theme_font_size_override("font_size", 26)
	coin_text.add_theme_color_override("font_color", Color("#2563eb"))
	menu_panel.add_child(coin_text)

	var play_button := make_big_button("OYNA", Color("#2563eb"), Color.WHITE)
	play_button.pressed.connect(func(): start_level(current_level_index))
	menu_panel.add_child(play_button)

	var reset_button := make_big_button("KAYDI SIFIRLA", Color("#e2e8f0"), Color("#0f172a"))
	reset_button.pressed.connect(func():
		current_level_index = 0
		coins = 0
		save_game()
		build_menu_panel()
	)
	menu_panel.add_child(reset_button)

	var note := Label.new()
	note.text = "MVP Sürüm • 20 Bölüm • Android APK Test"
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.add_theme_font_size_override("font_size", 18)
	note.add_theme_color_override("font_color", Color("#94a3b8"))
	menu_panel.add_child(note)

func build_game_panel() -> void:
	clear_children(game_panel)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 10)
	game_panel.add_child(top)

	level_label = Label.new()
	level_label.text = "Bölüm 1"
	level_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	level_label.add_theme_font_size_override("font_size", 26)
	level_label.add_theme_color_override("font_color", Color("#0f172a"))
	top.add_child(level_label)

	coins_label = Label.new()
	coins_label.text = "Coin: %d" % coins
	coins_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	coins_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	coins_label.add_theme_font_size_override("font_size", 24)
	coins_label.add_theme_color_override("font_color", Color("#2563eb"))
	top.add_child(coins_label)

	status_label = Label.new()
	status_label.text = "Ürün seç. Aynı üründen 3 tane slotta birleşince silinir."
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_font_size_override("font_size", 20)
	status_label.add_theme_color_override("font_color", Color("#475569"))
	game_panel.add_child(status_label)

	shelves_container = VBoxContainer.new()
	shelves_container.add_theme_constant_override("separation", 12)
	shelves_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	game_panel.add_child(shelves_container)

	slot_label = Label.new()
	slot_label.text = "Slotlar"
	slot_label.add_theme_font_size_override("font_size", 22)
	slot_label.add_theme_color_override("font_color", Color("#0f172a"))
	game_panel.add_child(slot_label)

	slots_container = HBoxContainer.new()
	slots_container.add_theme_constant_override("separation", 6)
	game_panel.add_child(slots_container)

	var bottom := HBoxContainer.new()
	bottom.add_theme_constant_override("separation", 10)
	game_panel.add_child(bottom)

	var restart_button := make_small_button("Tekrar", Color("#e2e8f0"), Color("#0f172a"))
	restart_button.pressed.connect(func(): start_level(current_level_index))
	bottom.add_child(restart_button)

	var menu_button := make_small_button("Menü", Color("#e2e8f0"), Color("#0f172a"))
	menu_button.pressed.connect(show_menu)
	bottom.add_child(menu_button)

func show_menu() -> void:
	menu_panel.visible = true
	game_panel.visible = false
	build_menu_panel()

func show_game() -> void:
	menu_panel.visible = false
	game_panel.visible = true

func start_level(index: int) -> void:
	if levels.is_empty():
		status_label.text = "Level datası bulunamadı."
		return
	if index >= levels.size():
		index = 0
		current_level_index = 0
	var level_data: Dictionary = levels[index]
	max_slots = int(level_data.get("slot_count", 7))
	selected_slots.clear()
	product_buttons.clear()
	remaining_products = 0
	level_label.text = "Bölüm %d / %d" % [index + 1, levels.size()]
	coins_label.text = "Coin: %d" % coins
	status_label.text = "Raflardan ürün seç. Slot dolmadan 3'lü eşleşme yap."
	clear_children(shelves_container)
	clear_children(slots_container)

	var rows: Array = level_data.get("rows", [])
	for row_index in range(rows.size()):
		var shelf := make_shelf_panel(row_index + 1)
		var grid := GridContainer.new()
		grid.columns = 4
		grid.add_theme_constant_override("h_separation", 8)
		grid.add_theme_constant_override("v_separation", 8)
		shelf.add_child(grid)
		var row: Array = rows[row_index]
		for product_id in row:
			var p_btn := make_product_button(str(product_id))
			p_btn.pressed.connect(func(pid := str(product_id), button := p_btn): on_product_pressed(pid, button))
			grid.add_child(p_btn)
			product_buttons.append(p_btn)
			remaining_products += 1
		shelves_container.add_child(shelf)

	refresh_slots()
	show_game()

func on_product_pressed(product_id: String, button: Button) -> void:
	if selected_slots.size() >= max_slots:
		return
	button.disabled = true
	button.visible = false
	remaining_products -= 1
	selected_slots.append({"id": product_id})
	refresh_slots()
	check_match(product_id)
	if remaining_products <= 0 and selected_slots.is_empty():
		on_level_win()
	elif selected_slots.size() >= max_slots:
		on_level_lose()

func check_match(product_id: String) -> void:
	var matching_indices: Array[int] = []
	for i in range(selected_slots.size()):
		if str(selected_slots[i].get("id", "")) == product_id:
			matching_indices.append(i)
	if matching_indices.size() >= 3:
		for n in range(2, -1, -1):
			selected_slots.remove_at(matching_indices[n])
		coins += 1
		status_label.text = "Güzel! 3 ürün eşleşti. +1 coin"
		coins_label.text = "Coin: %d" % coins
		save_game()
		refresh_slots()

func on_level_win() -> void:
	coins += 10
	current_level_index += 1
	if current_level_index >= levels.size():
		current_level_index = 0
	status_label.text = "Bölüm tamamlandı! +10 coin"
	coins_label.text = "Coin: %d" % coins
	save_game()
	await get_tree().create_timer(0.8).timeout
	start_level(current_level_index)

func on_level_lose() -> void:
	status_label.text = "Slotlar doldu. Tekrar dene."
	for b in product_buttons:
		b.disabled = true

func refresh_slots() -> void:
	clear_children(slots_container)
	for i in range(max_slots):
		var slot := Label.new()
		slot.custom_minimum_size = Vector2(86, 70)
		slot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		slot.add_theme_font_size_override("font_size", 16)
		if i < selected_slots.size():
			var product_id := str(selected_slots[i].get("id", ""))
			slot.text = get_product_label(product_id)
			slot.add_theme_stylebox_override("normal", make_style(get_product_color(product_id), Color("#cbd5e1"), 14))
		else:
			slot.text = ""
			slot.add_theme_stylebox_override("normal", make_style(Color("#ffffff"), Color("#cbd5e1"), 14))
		slots_container.add_child(slot)
	if slot_label != null:
		slot_label.text = "Slotlar: %d / %d" % [selected_slots.size(), max_slots]

func make_shelf_panel(num: int) -> MarginContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", make_style(Color("#ffffff"), Color("#dbeafe"), 18))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)
	return margin

func make_product_button(product_id: String) -> Button:
	var btn := Button.new()
	btn.text = get_product_label(product_id)
	btn.custom_minimum_size = Vector2(132, 72)
	btn.add_theme_font_size_override("font_size", 18)
	btn.add_theme_color_override("font_color", Color("#0f172a"))
	btn.add_theme_stylebox_override("normal", make_style(get_product_color(product_id), Color("#cbd5e1"), 14))
	btn.add_theme_stylebox_override("hover", make_style(get_product_color(product_id).lightened(0.06), Color("#94a3b8"), 14))
	btn.add_theme_stylebox_override("pressed", make_style(get_product_color(product_id).darkened(0.05), Color("#64748b"), 14))
	return btn

func make_big_button(text: String, bg: Color, fg: Color) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(1, 78)
	btn.add_theme_font_size_override("font_size", 28)
	btn.add_theme_color_override("font_color", fg)
	btn.add_theme_stylebox_override("normal", make_style(bg, bg.darkened(0.1), 18))
	btn.add_theme_stylebox_override("hover", make_style(bg.lightened(0.05), bg, 18))
	btn.add_theme_stylebox_override("pressed", make_style(bg.darkened(0.08), bg.darkened(0.2), 18))
	return btn

func make_small_button(text: String, bg: Color, fg: Color) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.custom_minimum_size = Vector2(1, 58)
	btn.add_theme_font_size_override("font_size", 22)
	btn.add_theme_color_override("font_color", fg)
	btn.add_theme_stylebox_override("normal", make_style(bg, bg.darkened(0.08), 14))
	return btn

func make_style(bg: Color, border: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(2)
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.content_margin_left = 8
	style.content_margin_right = 8
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func get_product_label(product_id: String) -> String:
	if PRODUCT_DEFS.has(product_id):
		return str(PRODUCT_DEFS[product_id].get("label", product_id.to_upper()))
	return product_id.to_upper()

func get_product_color(product_id: String) -> Color:
	if PRODUCT_DEFS.has(product_id):
		return PRODUCT_DEFS[product_id].get("color", Color.WHITE)
	return Color.WHITE

func clear_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()
