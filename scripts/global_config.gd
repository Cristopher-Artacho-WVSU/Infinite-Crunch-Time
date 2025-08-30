extends Node

var sample_debug_done := false
var sample_art_done := false
var sample_music_done := false

var intro_seen := false
var programming_praise_done := false
var art_praise_done := false
var music_praise_done := false

signal tasks_updated
var previous_scene_path := ""

func check_game_end():
	if sample_debug_done and sample_art_done:
		DialogueManager.show_dialogue_balloon(load("res://others/outro.dialogue"))
		go_back()
		emit_signal("tasks_updated")

func change_scene(scene: PackedScene):
	# Save current scene path
	previous_scene_path = get_tree().current_scene.scene_file_path
	# Change using a PackedScene
	get_tree().change_scene_to_packed(scene)

func go_back():
	if previous_scene_path != "":
		get_tree().change_scene_to_file(previous_scene_path)
