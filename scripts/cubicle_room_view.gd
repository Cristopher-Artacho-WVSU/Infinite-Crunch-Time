extends Node2D


#SCENES
var programmingWorkstation_scene = preload("res://scenes/programming_workstation.tscn")
var artWorkstation_scene = preload("res://scenes/art_workstation.tscn")
#var musicWorkstation_scene = preload("res://scenes/music_workstation.tscn")


func _ready():
	if GameState.sample_debug_done and GameState.sample_art_done:
		DialogueManager.show_dialogue_balloon(load("res://others/outro.dialogue"))
	elif GameState.programming_praise_done:
		DialogueManager.show_dialogue_balloon(load("res://others/programming_praise.dialogue"))
		GameState.programming_praise_done = false
	elif GameState.art_praise_done:
		DialogueManager.show_dialogue_balloon(load("res://others/art_praise.dialogue"))
		GameState.art_praise_done = false
		GameState.music_praise_done = false
	elif not GameState.intro_seen:
		DialogueManager.show_dialogue_balloon(load("res://others/intro.dialogue"))
		GameState.intro_seen = true

#CHANGE SCENES
func _on_programming_workstation_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if programmingWorkstation_scene:
			GameState.change_scene(programmingWorkstation_scene)

func _on_art_workstation_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if artWorkstation_scene:
			GameState.change_scene(artWorkstation_scene)

#func _on_music_workstation_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#print("Music workstation clicked")
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#if musicWorkstation_scene:
			#GameState.change_scene(musicWorkstation_scene)

func task_completion():
	pass
