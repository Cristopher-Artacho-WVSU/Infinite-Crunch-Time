extends Node2D


#SCENES
var programmingWorkstation_scene = preload("res://scenes/programming_workstation.tscn")
var artWorkstation_scene = preload("res://scenes/art_workstation.tscn")
var musicWorkstation_scene = preload("res://scenes/music_workstation.tscn")

#CHANGE SCENES
func _on_programming_workstation_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if programmingWorkstation_scene:
			get_tree().change_scene_to_packed(programmingWorkstation_scene)

func _on_art_workstation_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if programmingWorkstation_scene:
			get_tree().change_scene_to_packed(artWorkstation_scene)


func _on_music_workstation_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if programmingWorkstation_scene:
			get_tree().change_scene_to_packed(musicWorkstation_scene)
