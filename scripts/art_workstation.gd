extends Node2D

@export var source_image_texture: Texture2D = preload("res://assets/objects/red_button.png")
@export var pixel_size: int = 3

#@onready var animation = $AnimatedSprite2D 

# --- Internal state ---
var color_to_index: Dictionary = {}   # key: String(color), value: int index
var index_to_color: Dictionary = {}   # key: int index, value: Color
var tile_nodes: Dictionary = {}       # key: Vector2i(grid_x,grid_y), value: PanelContainer
var selected_index: int = -1          # explicitly typed to avoid "null" inference error


	
func _ready() -> void:
#	FOR THE BACKGROUND
	#animation.play("bg")
	image_conversion()



func _on_back_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("clicked back button")
		GameState.go_back()
	
func image_conversion():
	#READ IMAGE AND CONVERT IT TO RGBA8 FORMAT IF IT ISN'T RGBA8
	var img: Image = source_image_texture.get_image()
	img.convert(Image.FORMAT_RGBA8)
	
#	ASSIGN COLOR INDEXES
	var next_number: int = 1
	var img_w := img.get_width()
	var img_h := img.get_height()

#	CENTER THE POSITIONING OF IMAGE 
	var grid_size_pixels := Vector2(img_w * pixel_size, img_h * pixel_size)
	var offset := (get_viewport_rect().size - grid_size_pixels) / 2.0

	# GENERATE THE TILES
	for y in range(img_h):
		for x in range(img_w):
			var color: Color = img.get_pixel(x, y)
#			SKIP IF TRANSPARENT
			if color.a < 0.1:
				continue
			
#			MAP THE COLORED PIXELS INTO NUMBERS
			var color_key := str(color)
			if not color_to_index.has(color_key):
				color_to_index[color_key] = next_number
				index_to_color[next_number] = color
				next_number += 1
			var num: int = color_to_index[color_key]
			
#			ADD NUMBERS TO THE TILES
			var grid_pos: Vector2i = Vector2i(x, y)
			var tile := PanelContainer.new()
			tile.name = "Tile_%d_%d" % [x, y]
			tile.position = offset + Vector2(x * pixel_size, y * pixel_size)
			tile.custom_minimum_size = Vector2(pixel_size, pixel_size)

			# DECORATE THE TILES WITH WHITE BACKGROUND AND BLACK BORDER
			var sb := StyleBoxFlat.new()
			sb.bg_color = Color.WHITE
			sb.border_color = Color.BLACK
			sb.border_width_left = 1
			sb.border_width_top = 1
			sb.border_width_right = 1
			sb.border_width_bottom = 1
			tile.add_theme_stylebox_override("panel", sb)

			# number label
			var label := Label.new()
			label.name = "NumberLabel"
			label.text = str(num)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			label.custom_minimum_size = Vector2(pixel_size, pixel_size)
			label.modulate = Color.BLACK
			label.mouse_filter = Control.MOUSE_FILTER_IGNORE
			tile.add_child(label)

			# metadata
			tile.set_meta("number", num)
			tile.set_meta("grid_pos", grid_pos)
			tile.set_meta("filled", false)

			# clickable via gui_input
			tile.mouse_filter = Control.MOUSE_FILTER_STOP
			tile.gui_input.connect(Callable(self, "_on_tile_gui_input").bind(tile))

			add_child(tile)
			tile_nodes[grid_pos] = tile

	# create palette
	_create_palette(next_number)

func _create_palette(total_colors: int) -> void:
	# simple HBox placed at top-left (adjust as desired)
	var palette_panel := HBoxContainer.new()
	palette_panel.position = Vector2(10, 10)
	add_child(palette_panel)

	for i in range(1, total_colors):
		var btn := Button.new()
		btn.text = str(i)
		btn.custom_minimum_size = Vector2(40, 40)

		# style button background with the color
		var style := StyleBoxFlat.new()
		style.bg_color = index_to_color[i]
		style.border_color = Color.BLACK
		style.border_width_left = 1
		style.border_width_top = 1
		style.border_width_right = 1
		style.border_width_bottom = 1
		btn.add_theme_stylebox_override("normal", style)
		# ensure the number text is readable (black)
		btn.add_theme_color_override("font_color", Color.BLACK)

		# connect with bound index
		btn.pressed.connect(Callable(self, "_on_palette_selected").bind(i))
		palette_panel.add_child(btn)


func _on_palette_selected(index: int) -> void:
	selected_index = index
	print("Selected color index:", index)


# gui_input handler for each tile (tile is bound as extra arg)
func _on_tile_gui_input(event: InputEvent, tile: PanelContainer) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var tile_number: int = tile.get_meta("number")
		if tile_number == selected_index:
			var start_pos: Vector2i = tile.get_meta("grid_pos")
			_flood_fill(start_pos, tile_number)


# BFS flood-fill on 4 neighbors; instead of freeing nodes we recolor the tile's style and hide the number
# BFS flood-fill on 4 neighbors; instead of freeing nodes we recolor the tile's style and hide the number
func _flood_fill(start_pos: Vector2i, num: int) -> void:
	var color: Color = index_to_color[num]
	var queue: Array = [start_pos]
	var visited: Dictionary = {}

	while queue.size() > 0:
		var pos: Vector2i = queue.pop_front()
		if visited.has(pos):
			continue
		visited[pos] = true

		if not tile_nodes.has(pos):
			continue
		var tile: PanelContainer = tile_nodes[pos]
		if tile.get_meta("number") != num:
			continue
		if tile.get_meta("filled") == true:
			continue

		# apply filled style (no borders this time)
		var sb := StyleBoxFlat.new()
		sb.bg_color = color
		sb.border_color = Color.TRANSPARENT
		sb.border_width_left = 0
		sb.border_width_top = 0
		sb.border_width_right = 0
		sb.border_width_bottom = 0
		tile.add_theme_stylebox_override("panel", sb)

		# hide number label
		var lbl := tile.get_node_or_null("NumberLabel")
		if lbl:
			lbl.visible = false

		tile.set_meta("filled", true)

		# enqueue 4-neighbors
		for d in [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]:
			queue.append(pos + d)
			
	_check_completion()
	print("Flood-filled region with number", num)
	
func _check_completion() -> void:
	for tile in tile_nodes.values():
		if tile.get_meta("filled") == false:
			return # stop early if we find at least one unfilled tile
#		Art task completed
		GameState.sample_art_done = true
		GameState.art_praise_done = true
		get_tree().change_scene_to_file.call_deferred("res://scenes/cubicleRoom_view.tscn")
