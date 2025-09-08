extends Control

var sequence = []
var player_sequence = []
var current_index = 0
var buttons = []
var sounds = []
var audio_player
var is_player_turn = false

var round_label

func _ready():
	randomize()
	buttons = [
		$GridContainer/TextureButton,
		$GridContainer/TextureButton2,
		$GridContainer/TextureButton3,
		$GridContainer/TextureButton4,
		$GridContainer/TextureButton5,
		$GridContainer/TextureButton6,
		$GridContainer/TextureButton7,
		$GridContainer/TextureButton8,
		$GridContainer/TextureButton9
	]
	sounds = [
		preload("res://assets/sounds/D#6.ogg"),
		preload("res://assets/sounds/C#6.ogg"),
		preload("res://assets/sounds/A#5.ogg"),
		preload("res://assets/sounds/F#5.ogg"),
		preload("res://assets/sounds/D#5.ogg"),
		preload("res://assets/sounds/C#5.ogg"),
		preload("res://assets/sounds/F#4.ogg"),
		preload("res://assets/sounds/D#4.ogg"),
		preload("res://assets/sounds/C#4.ogg"),
		preload("res://assets/sounds/failed.mp3")  # for wrong
	]
	audio_player = $AudioStreamPlayer
	round_label = $RoundLabel
	start_game()

func start_game():
	sequence = []
	player_sequence = []
	current_index = 0
	add_random_note()
	update_round_label()
	play_sequence()

func update_round_label():
	round_label.text = "Sequence Length: " + str(sequence.size())

func add_random_note():
	var rand_index = randi() % 9
	sequence.append(rand_index)



func play_sequence():
	is_player_turn = false
	for button in buttons:
		button.disabled = true
	for note in sequence:
		await get_tree().create_timer(0.5).timeout
		buttons[note].self_modulate *= 2  # brighter
		audio_player.stream = sounds[note]
		audio_player.play()
		await get_tree().create_timer(0.5).timeout
		buttons[note].self_modulate /= 2
	await get_tree().create_timer(0.5).timeout
	for button in buttons:
		button.disabled = false
	is_player_turn = true

func _on_button_pressed(index):
	if not is_player_turn:
		return
	player_sequence.append(index)
	audio_player.stream = sounds[index]
	audio_player.play()
	if player_sequence[current_index] != sequence[current_index]:
		# wrong
		audio_player.stream = sounds[9]  # failed
		audio_player.play()
		await get_tree().create_timer(1.0).timeout
		# reset current sequence
		player_sequence = []
		current_index = 0
		play_sequence()
		return
	current_index += 1
	if current_index == sequence.size():
		# sequence complete
		if sequence.size() == 5:
			play_melody()
			await get_tree().create_timer(2.0).timeout
			get_tree().change_scene_to_file("res://scenes/main.tscn")
		else:
			player_sequence = []
			current_index = 0
			add_random_note()
			update_round_label()
			play_sequence()

func play_melody():
	is_player_turn = false
	for note in sequence:
		audio_player.stream = sounds[note]
		audio_player.play()
		await get_tree().create_timer(0.6).timeout
