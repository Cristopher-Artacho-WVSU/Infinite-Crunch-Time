extends Node

#TASKS PER DAY
var programming_tasks_left = 6
var artwork_taks_left = 6
var music_tasks_left = 6

#VARIABLE FOR THE ENERGY
var energy = 100

var efficiency_buff = false

#VARIABLES FOR THE QUOTA
var programmingTasks = 0
var artworkTasks = 0
var musicTasks = 0

#VARIABLES FOR TIME
var current_time = 6
var finish_time = 18
var days_left = 3

# BOOL VARIABLES FOR DAY FINISHED
var finished_programming_task = false
var finished_artwork_task = false
var finished_music_task = false

#WHEN RESETTING THE DAY
func reset_day():
	current_time = 6
	programmingTasks = 0
	artworkTasks = 0
	musicTasks = 0
func game_over():
	get_tree().quit()

func monitor_tasks():
	pass
