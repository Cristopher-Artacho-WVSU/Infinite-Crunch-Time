extends Node


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

# BOOL VARIABLES
var finished_programming_task = false
var finished_artwork_task = false
var finished_music_task = false

#WHEN RESETTING THE DAY
func reset_day():
	current_time = 6
	finished_programming_task = false
	finished_artwork_task = false
	finished_music_task = false

func game_over():
	get_tree().quit()
