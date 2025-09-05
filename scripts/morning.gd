extends TextureRect

func _on_art_button_pressed() -> void:
	GlobalConfig.energy -= 30
	get_tree().change_scene_to_file("res://scenes/noon.tscn")
	pass # Replace with function body.


func _on_programming_button_pressed() -> void:
	GlobalConfig.energy -= 30
	get_tree().change_scene_to_file("res://scenes/noon.tscn")
	pass # Replace with function body.


func _on_music_button_pressed() -> void:
	GlobalConfig.energy -= 30
	get_tree().change_scene_to_file("res://scenes/noon.tscn")
	pass # Replace with function body.


func _on_side_quests_button_pressed() -> void:
	GlobalConfig.energy -= 30
	get_tree().change_scene_to_file("res://scenes/noon.tscn")
	pass # Replace with function body.

func _ready() -> void:
	var energy_bar = $HeaderMargin/Header/EnergyBar
	energy_bar.value = GlobalConfig.energy
