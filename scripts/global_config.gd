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

#WHEN RESETTING THE DAY
func reset_day():
	current_time =6

func game_over():
	get_tree().quit()
