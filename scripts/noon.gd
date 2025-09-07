extends TextureRect

func _ready() -> void:
	var energy_bar = $HeaderMargin/Header/EnergyBar
	energy_bar.value = GlobalConfig.energy

func _on_eat_pressed() -> void:
	GlobalConfig.energy += 50
	get_tree().change_scene_to_file("res://scenes/afternoon.tscn")
	pass # Replace with function body.

func _on_social_media_buttom_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/afternoon.tscn")
	pass # Replace with function body.

func _on_tutorial_review_button_pressed() -> void:
	GlobalConfig.efficiency_buff = true
	get_tree().change_scene_to_file("res://scenes/afternoon.tscn")
	pass # Replace with function body.

func _on_side_quests_button_pressed() -> void:
	GlobalConfig.energy -= 30
	get_tree().change_scene_to_file("res://scenes/afternoon.tscn")
	pass # Replace with function body.
