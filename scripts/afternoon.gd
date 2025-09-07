extends TextureRect

func _on_art_button_pressed() -> void:
	GlobalConfig.energy -= 30
	get_tree().change_scene_to_file("res://scenes/evening.tscn")
	pass # Replace with function body.

func _on_programming_button_pressed() -> void:
	GlobalConfig.energy -= 30
	get_tree().change_scene_to_file("res://scenes/evening.tscn")
	pass # Replace with function body.

func _on_music_button_pressed() -> void:
	GlobalConfig.energy -= 30
	get_tree().change_scene_to_file("res://scenes/evening.tscn")
	pass # Replace with function body.

func _on_resume_button_pressed() -> void:
	GlobalConfig.energy -= 30
	get_tree().change_scene_to_file("res://scenes/evening.tscn")
	pass # Replace with function body.
