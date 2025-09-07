extends TextureRect

@onready var timer = $HeaderMargin/Header/Timer 
@onready var current_time = $HeaderMargin/Header/Time
@onready var daysLeft_label = $HeaderMargin/Header/TurnsLeft

func _ready() -> void:
	
	pass

func _physics_process(delta):
#	GAME OVER IF THE NUMBER OF DAYS IS 0 AND TIME IS 6PM
	if GlobalConfig.days_left <= 0 and GlobalConfig.current_time >= 18:
		GlobalConfig.game_over()
	display_time()


func _on_art_button_pressed() -> void:
	GlobalConfig.current_time += 2
	pass # Replace with function body.

func _on_programming_button_pressed() -> void:
	pass # Replace with function body.

func _on_music_button_pressed() -> void:
	pass # Replace with function body.

func _on_resume_button_pressed() -> void:
	pass # Replace with function body.
	

#	LOGIC FOR DISPLAYING THE CURRENT TIME
func display_time():
	daysLeft_label.text = str("    Days Left: ", GlobalConfig.days_left)
	
	if GlobalConfig.current_time < 12:
		current_time.text = str(GlobalConfig.current_time) + ":00AM     "
	else:
		current_time.text = str(GlobalConfig.current_time - 12) + ":00PM     "

	# Check if we passed the end of the day (e.g., after 6PM)
	if GlobalConfig.current_time >= 18:
		GlobalConfig.reset_day()
		GlobalConfig.days_left -= 1
		current_time.text = str(GlobalConfig.current_time) + ":00AM     "
