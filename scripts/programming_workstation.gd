extends Control

var levels = [
	{
		"question": "print(\"Hello, ___!\")",
		"answers": ["World"],
		"choices": ["World", "Godot", "Player", "Game"]
	},
	{
		"question": "Correct syntax for a GDScript function: func ___():",
		"answers": ["my_function"],
		"choices": ["my_function", "function my_function", "func my_function", "def my_function()"]
	},
	{
		"question": "Which is a loop in GDScript?",
		"answers": ["for"],
		"choices": ["for", "if", "print", "var"]
	},
	{
		"question": "Debug: print(\"Hello \" + name) Error: name not defined. Fix:",
		"answers": ["var name = \"value\""],
		"choices": ["define name", "var name", "var name = \"value\"", "print(name)"]
	},
	{
		"question": "What does 'if' do in GDScript?",
		"answers": ["checks condition"],
		"choices": ["checks condition", "loops", "prints text", "defines variable"]
	}
]

var current_level = 0
var current_answers = []
var equilibrio_score = 50.0



# Preload button textures
@onready var yellow_tex = preload("res://assets/objects/yellow_button.png")
@onready var blue_tex   = preload("res://assets/objects/blue_button.png")
@onready var green_tex  = preload("res://assets/objects/green_button.png")
@onready var red_tex    = preload("res://assets/objects/red_button.png")

#@onready var yellow_tex = preload("res://assets/objects/540491142_1319311699555652_5210820869862362498_n(1).png")
#@onready var blue_tex   = preload("res://assets/objects/540530134_761505430065178_3738801461398201083_n(1).png")
#@onready var green_tex  = preload("res://assets/objects/green_button.png")
#@onready var red_tex    = preload("res://assets/objects/540251709_1269751374750826_5552306563604744549_n(1).png")
func _ready():

	# Center the container
	$ChoicesCenter.set_anchors_preset(Control.PRESET_CENTER)
	$ChoicesCenter.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	$ChoicesCenter.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# Add padding: 10px X-axis, 5px Y-axis
	if $ChoicesCenter/ChoicesContainer is GridContainer or $ChoicesCenter/ChoicesContainer is VBoxContainer or $ChoicesCenter/ChoicesContainer is HBoxContainer:
		$ChoicesCenter/ChoicesContainer.add_theme_constant_override("h_separation", 10)
		$ChoicesCenter/ChoicesContainer.add_theme_constant_override("v_separation", 20)
	
	# Load current level
	var level = levels[current_level]
	var question_text = level["question"]
	current_answers = level["answers"]
	var choices = level["choices"]

	# Set level and question
	$LevelLabel.text = "Level " + str(current_level + 1)
	$TextPanel/CodeText.text = question_text
	$Feedback.text = ""
	$EquilibrioScale.value = equilibrio_score

	# Clear old choice buttons
	for child in $ChoicesCenter/ChoicesContainer.get_children():
		child.queue_free()

	# If it's a GridContainer, set 2 columns
	if $ChoicesCenter/ChoicesContainer is GridContainer:
		$ChoicesCenter/ChoicesContainer.columns = 2  

	# Generate buttons with custom backgrounds
	var textures = [yellow_tex, blue_tex, green_tex, red_tex]
	for i in range(choices.size()):
		var choice = choices[i]
		var btn = Button.new()
		btn.text = choice

		# Pick texture based on index
		var stylebox = StyleBoxTexture.new()
		if i < textures.size():
			stylebox.texture = textures[i]

		# Scale button size
		if stylebox.texture:
			var tex_size = stylebox.texture.get_size()
			btn.custom_minimum_size = tex_size * 2  # make it smaller
		else:
			btn.custom_minimum_size = Vector2(120, 60)

		# Apply stylebox to all button states
		btn.add_theme_stylebox_override("normal", stylebox)
		btn.add_theme_stylebox_override("hover", stylebox)
		btn.add_theme_stylebox_override("pressed", stylebox)
		btn.add_theme_stylebox_override("disabled", stylebox)

		# Make text more visible
		btn.add_theme_color_override("font_color", Color.BLACK)

		# Connect button signal
		btn.pressed.connect(_on_choice_pressed.bind(choice))
		$ChoicesCenter/ChoicesContainer.add_child(btn)

func _on_choice_pressed(choice: String):
	if choice in current_answers:
		$Feedback.text = "✅ Correct!"
		$Feedback.add_theme_color_override("font_color", Color(0, 1, 0))
		equilibrio_score = clamp(equilibrio_score + 10, 0, 100)
		# Progress to next level
		current_level += 1
		if current_level < levels.size():
			_ready()  # Reload next level
		else:
			$Feedback.text = "All levels completed!"
			GameState.sample_debug_done = true
			GameState.programming_praise_done = true
			get_tree().change_scene_to_file("res://scenes/cubicleRoom_view.tscn")
	else:
		$Feedback.text = "Try again!"
		$Feedback.add_theme_color_override("font_color", Color(1, 0, 0))
		equilibrio_score = clamp(equilibrio_score - 5, 0, 100)
	$EquilibrioScale.value = equilibrio_score

func _on_back_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("clicked back button")
		GameState.go_back()
