extends Node2D

var composition_list
var feedback_label
var audio_player

var composition = []

# Audio streams
@onready var drum_stream = preload("res://assets/audio/drum_pop.mp3")
@onready var melody_stream = preload("res://assets/audio/piano_note.mp3")
@onready var bass_stream = preload("res://assets/audio/piano_low.mp3")

# Textures
@onready var drum_tex = preload("res://assets/objects/Music/drum.png")
@onready var melody_tex = preload("res://assets/objects/Music/piano.png")
@onready var bass_tex = preload("res://assets/objects/Music/lute.png")

var audio_players = []

var music_levels = [
	{
		"challenge": "Create happy music: add Drum Loop and Melody",
		"required": ["Drum Loop", "Melody"]
	},
	{
		"challenge": "Create sad music: add Bass and Melody",
		"required": ["Bass", "Melody"]
	},
	{
		"challenge": "Create energetic music: add Drum Loop, Melody, and Bass",
		"required": ["Drum Loop", "Melody", "Bass"]
	}
]

var current_challenge = 0
var current_required = []

func _ready():
	print("Music workstation ready")
	composition_list = get_node("CanvasLayer/UI/CompositionArea/CompositionList")
	feedback_label = get_node("CanvasLayer/UI/FeedbackLabel")
	audio_player = get_node("AudioPlayer")
	var equilibrio_scale = get_node("CanvasLayer/UI/EquilibrioScale")
	
	var challenge = music_levels[current_challenge]["challenge"]
	var level_label = get_node("CanvasLayer/UI/Title")  # Using Title as level label
	if level_label:
		level_label.text = "Challenge " + str(current_challenge + 1) + ": " + challenge
	current_required = music_levels[current_challenge]["required"]
	
	var text_label = get_node("CanvasLayer/UI/TextPanel/CodeText")
	if text_label:
		text_label.text = challenge
	
	var drum_area = get_node("DrumInstrument")
	if drum_area:
		drum_area.connect("input_event", Callable(self, "_on_instrument_input").bind("Drum Loop"))
	
	var melody_area = get_node("MelodyInstrument")
	if melody_area:
		melody_area.connect("input_event", Callable(self, "_on_instrument_input").bind("Melody"))
	
	var bass_area = get_node("BassInstrument")
	if bass_area:
		bass_area.connect("input_event", Callable(self, "_on_instrument_input").bind("Bass"))
	
	var play_button = get_node("CanvasLayer/UI/PlayButton")
	if play_button:
		play_button.connect("pressed", Callable(self, "_play_composition"))

func _add_pattern(pattern_name):
	composition.append(pattern_name)
	if composition_list:
		var tex_rect = TextureRect.new()
		if pattern_name == "Drum Loop":
			tex_rect.texture = drum_tex
		elif pattern_name == "Melody":
			tex_rect.texture = melody_tex
		elif pattern_name == "Bass":
			tex_rect.texture = bass_tex
		tex_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		tex_rect.custom_minimum_size = Vector2(50, 50)
		composition_list.add_child(tex_rect)

func _play_composition():
	if composition.is_empty():
		if feedback_label:
			feedback_label.text = "No patterns added!"
		return
	
	# Stop previous playback
	_stop_all_audio()
	
	# Play composition
	for pattern in composition:
		var player = AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)
		if pattern == "Drum Loop":
			player.stream = drum_stream
		elif pattern == "Melody":
			player.stream = melody_stream
		elif pattern == "Bass":
			player.stream = bass_stream
		player.play()
	
	# Validation
	var valid = true
	for req in current_required:
		if not (req in composition):
			valid = false
			break
	if feedback_label:
		if valid:
			feedback_label.text = "Great composition! Challenge completed."
			current_challenge += 1
			if current_challenge < music_levels.size():
				_ready()  # Reload next challenge
			else:
				feedback_label.text = "All challenges completed!"
				GameState.sample_music_done = true
				GameState.music_praise_done = true
				get_tree().change_scene_to_file.call_deferred("res://scenes/cubicleRoom_view.tscn")
		else:
			feedback_label.text = "Needs improvement. Add required patterns."

func _on_instrument_input(viewport, event, shape_idx, pattern_name):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_add_pattern(pattern_name)

func _stop_all_audio():
	for player in audio_players:
		player.stop()
		player.queue_free()
	audio_players.clear()
