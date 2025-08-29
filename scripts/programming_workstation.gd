extends Control

var question_text = "Hello, ___!"
var answers = ["World"]  
var choices = ["World", "Godot", "Player", "Game"]



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
	$ChoicesContainer.set_anchors_preset(Control.PRESET_CENTER)
	$ChoicesContainer.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	$ChoicesContainer.size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# Add padding: 10px X-axis, 5px Y-axis
	if $ChoicesContainer is GridContainer or $ChoicesContainer is VBoxContainer or $ChoicesContainer is HBoxContainer:
		$ChoicesContainer.add_theme_constant_override("h_separation", 10)
		$ChoicesContainer.add_theme_constant_override("v_separation", 20)
	
	# Set question
	$CodeText.text = question_text
	$Feedback.text = ""

	# Clear old choice buttons
	for child in $ChoicesContainer.get_children():
		child.queue_free()

	# If it's a GridContainer, set 2 columns
	if $ChoicesContainer is GridContainer:
		$ChoicesContainer.columns = 2  

	# Generate buttons with custom backgrounds
	for choice in choices:
		var btn = Button.new()
		btn.text = choice

		# Pick texture based on choice
		var stylebox = StyleBoxTexture.new()
		match choice:
			"World":
				stylebox.texture = yellow_tex
			"Godot":
				stylebox.texture = blue_tex
			"Player":
				stylebox.texture = green_tex
			"Game":
				stylebox.texture = red_tex

		# Scale button size = 3x texture size
		if stylebox.texture:
			var tex_size = stylebox.texture.get_size()
			btn.custom_minimum_size = tex_size * 2  # make it 3x bigger

		# Apply stylebox to all button states
		btn.add_theme_stylebox_override("normal", stylebox)
		btn.add_theme_stylebox_override("hover", stylebox)
		btn.add_theme_stylebox_override("pressed", stylebox)
		btn.add_theme_stylebox_override("disabled", stylebox)

		# Make text more visible
		btn.add_theme_color_override("font_color", Color.BLACK)

		# Connect button signal
		btn.pressed.connect(_on_choice_pressed.bind(choice))
		$ChoicesContainer.add_child(btn)

func _on_choice_pressed(choice: String):
	if choice in answers:
		$Feedback.text = "✅ Correct!"
		$Feedback.add_theme_color_override("font_color", Color(0, 1, 0))
	else:
		$Feedback.text = "❌ Try again!"
		$Feedback.add_theme_color_override("font_color", Color(1, 0, 0))
