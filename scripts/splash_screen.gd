extends Control

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("fade_in")

func _on_play_pressed():
	# Change to main game scene
	get_tree().change_scene_to_file("res://scenes/cubicleRoom_view.tscn")  # Assuming this is the main scene

func _on_options_pressed():
	# Open options menu or scene
	pass  # Placeholder for options
