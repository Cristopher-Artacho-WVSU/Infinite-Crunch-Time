extends TextureRect

@onready var code = $desktop_monitor/TextMargin/Code
@onready var problem_section = $problem_note
@onready var choices = $choices_container
@onready var timer_label = $timer_label
@onready var timer = $timer_label/Timer

@onready var button_bg = preload("res://assets/objects/blue_button.png")
@onready var button_font = preload("res://fonts/Pixel Digivolve/Pixel Digivolve.otf")

var quiz_stage: int = 0
var total_time: int = 120
var current_category: Array = []
var category_index: int = 0   # which category inside today's two

# ================== QUIZ DATA ==================
var player_movements =  [
 {
	"program": 
	"\nvar gravity: float = ProjectSettings.get_setting(\"physics/2d/default_gravity\")" \
	+ "\n" \
	+ "\nfunc _physics_process(delta: float) -> void:" \
	+ "\n\tplayer_movement()" \
	+ "\n\tplayer_jump()" \
	+ "\n\tif not is_on_floor():" \
	+ "\n\t\tvelocity.y += gravity * delta" \
	+ "\n\telse:" \
	+ "\n\t\tvelocity.y = 0",
		"problem" : "I am trying to make my character move, but it just gets stuck mid-air, what could be missing?",
		"choices" : ["move_and_slide()", "move()", "execute()", "print()"],
		"correct_choice": "move_and_slide()"},
	
{
	"program":
		"@export var speed: float = 200" \
	+ "\n\nfunc player_movement():" \
	+ "\n\tvelocity.x = 0" \
	+ "\n\tif Input.is_action_pressed(\"ui_right\"):" \
	+ "\n\t\tvelocity.x += speed" \
	+ "\n\tif Input.is_action_pressed(\"ui_left\"):" \
	+ "\n\t\t velocity.y -= speed",
	"problem":"I am trying to make my character go to the left, but it just jumps. What could the error be?",
	"choices": ["-= speed", "velocity.y", "velocity.x", "+= speed"],
	"correct_choice": "velocity.y"
},
{
	"program":
	"@export var jump_force: float = -400" \
	+ "\n\nfunc player_jump():" \
	+ "\n\tif Input.is_action_just_pressed(\"ui_accept\") and is_on_floor():" \
	+ "\n\t\tvelocity.y = -jump_force",
	"problem":"I am trying to make the player jump if I pressed space, but it does not. What is the error?",
	"choices": ["-jump_force", "ui_accept", "jump_float", "velocity.y"],
	"correct_choice": "-jump_force"
}]

var item_mechanics = [
	{
		"program": "extends Area2D" \
		+ "\n" \
		+ "\n@onready var sprite = $Sprite2D" \
		+ "\n@onready var collision = $CollisionShape2D" \
		+ "\n@onready var respawn_timer = $Timer" \
		+ "\n" \
		+ "\nfunc _ready() -> void:" \
		+ "\n\tarea_entered.connect(_on_area_entered)" \
		+ "\n\ttimer.one_shot = true" \
		+ "\n\ttimer.wait_time = 5.0" \
		+ "\n" \
		+ "\nfunc _on_area_entered(area: Area2D) -> void:" \
		+ "\n\tif area.name == \"body_collision\":" \
		+ "\n\t\thide_item()" \
		+ "\n\t\timer.start()",
		
		"problem": 'I want to make a timer for my item to respawn and made configurations. However, this error occurs: "Identifier "timer" not declared in the current scope." How do I fix this?',
		"choices": ["respawn_timer", "sprite", "wait_time", "area_entered.connect"],
		"correct_choice": "respawn_timer"
	},

	{
		"program": 
			"\n@onready var sprite = $Sprite2D" \
		+ "\\nnfunc _on_area_entered(area: Area2D) -> void:" \
		+ "\n\tif area.name == \"hurtbox\":" \
		+ "\n\t\thide_item()" \
		+ "\n\t\trespawn_timer.start()" \
		+ "\n" \
		+ "\nfunc hide_item() -> void:" \
		+ "\n\tsprite.show()" \
		+ "\n\tcollision.disabled = true",
		
		"problem": 'I am trying to make my item disappear if it enters an Area2D named "hurtbox", but it does not disappear. What could the error be?',
		"choices": ["collision.disabled", "sprite.show()", "respawn_timer", "area.name"],
		"correct_choice": "sprite.show()"
	},

	{
		"program": "func _on_RespawnTimer_timeout() -> void:" \
		+ "\n\tshow_items()" \
		+ "\n" \
		+ "\nfunc show_item() -> void:" \
		+ "\n\tsprite.show()" \
		+ "\n\tcollision.disabled = false",
		
		"problem": 'This time, "Function "show_items()" not found in base self." is the error that appears. What should I replace with show_items()?',
		"choices": ["show_item()", "sprite.show()", "_on_RespawnTimer_timeout()", "collision.disabled"],
		"correct_choice": "show_item()"
	}
]


var enemy_movement = [
	{
		"program": "extends CharacterBody2D" \
	+ "\n" \
	+ "\n" \
	+ "\nvar player: Node = null" \
	+ "\n" \
	+ "\n@onready var vision_area = $enemy_detect" \
	+ "\n" \
	+ "\nfunc _ready() -> void:" \
	+ "\n\tvision.area_entered.connect(_on_VisionArea_area_entered)" \
	+ "\n\tvision.area_exited.connect(_on_VisionArea_area_exited)" \
	+ "\n" \
	+ "\nfunc _on_VisionArea_area_entered(area: Area2D) -> void:" \
	+ "\n\tif area.name == \"hurtbox\":" \
	+ "\n\t\tplayer = area" \
	+ "\n" \
	+ "\nfunc _on_VisionArea_area_exited(area: Area2D) -> void:" \
	+ "\n\tif area == player:" \
	+ "\n\t\tplayer = null",
		
		"problem": 'I am planning to make an enemy, and add an area to detect the player. However, it only outputs "Identifier "vision" not declared in the current scope." What should I replace "vision" with?',
		"choices": ["visions", "visionArea", "player", "vision_area"],
		"correct_choice": "vision_area"
	},

	{
		"program": "\n@export var speed: float = 50" \
	+"func enemy_movement():" \
	+ "\n\tif player:" \
	+ "\n\t\t# Move towards player" \
	+ "\n\t\tvar direction = (player.global_position - global_position).normalized()" \
	+ "\n\t\tvelocity = direction * speed" \
	+ "\n\telse:" \
	+ "\n\t\tvelocity = 0",
		
		"problem": 'I am trying to make my enemy move horizontally, but it also moves vertically without falling. What could the error be?',
		"choices": ["direction", "speed", "velocity", "velocity.x"],
		"correct_choice": "velocity"
	}
]

var mob_mechanics = [
	{
		"program": "@export var speed: float = 50" \
		+ "\nvar player: Node = null" \
		+ "\nvar is_dead: bool = false" \
		+ "\n" \
		+ "\n@onready var vision_area = $enemy_detect" \
		+ "\n@onready var respawn_timer: Timer = $Timer" \
		+ "\n@onready var hitbox = $\"body_hitbox&hurtbox\"" \
		+ "\n" \
		+ "\nvar gravity: float = ProjectSettings.get_setting(\"physics/2d/default_gravity\")" \
		+ "\n" \
		+ "\nfunc _ready() -> void:" \
		+ "\n\thitbox.area_entered.connect(on_enemy_hits_player)" \
		+ "\n" \
		+ "\n" \
		+ "\nfunc on_enemy_hits_player(area: Area2D) -> void:" \
		+ "\n\tif collision.name == \"hurtbox\": " \
		+ "\n\t\tprint(\"player is damaged\")",

		
		"problem": 'Assuming that the "hurtbox" is the hurtbox (AREA2D) of the player, why does this not collide with the AREA2D of the enemy?',
		"choices": ["collision", "vision_area", "hitbox", "hurtbox"],
		"correct_choice": "collision"
	},

	{
		"program": "extends CharacterBody2D" \
	+ "\n" \
	+ "\n@export var speed: float = 50" \
	+ "\nvar player: Node = null" \
	+ "\nvar is_dead: bool = false" \
	+ "\n" \
	+ "\n@onready var vision_area = $enemy_detect" \
	+ "\n@onready var respawn_timer: Timer = $Timer" \
	+ "\n@onready var hitbox = $\"body_hitbox&hurtbox\"" \
	+ "\n" \
	+ "\nvar gravity: float = ProjectSettings.get_setting(\"physics/2d/default_gravity\")" \
	+ "\n" \
	+ "\nfunc _ready() -> void:" \
	+ "\n\thitbox.area_entered.connect(on_enemy_hits_player)" \
	+ "\n\thitbox.area_entered.connect(on_player_attack_hits_enemy)" \
	+ "\n" \
	+ "\nfunc on_player_attack_hits_enemy(area: Area2D) -> void:" \
	+ "\n\tif area.name == \"hurtbox\":  # adjust to your player's attack/hitbox node" \
	+ "\n\t\tdie()",
		
		"problem": 'Now I am making a way to defeat the enemy, however it seems that the enemy dies instead of damaging the player, what is the error?',
		"choices": ["area", "hitbox", "die()", "hurtbox"],
		"correct_choice": "hurtbox"
	},

	{
		"program": "func die() -> void:" \
	+ "\n\tif not is_dead:" \
	+ "\n\t\tis_dead = true" \
	+ "\n\t\thide()" \
	+ "\n\t\t$base_collision.disabled = true" \
	+ "\n\t\tvision_area.monitoring = false" \
	+ "\n\t\tvelocity = Vector2.ZERO" \
	+ "\n\t\trespawn_timer.start()" \
	+ "\n" \
	+ "\nfunc _on_respawn_timeout() -> void:" \
	+ "\n\tis_dead = true" \
	+ "\n\tshow()" \
	+ "\n\t$base_collision.disabled = false" \
	+ "\n\tvision_area.monitoring = true",

		
		"problem": 'Upon death, the enemy it should be resurrected after 10 seconds and can be defeated again and will disappear. However, it does not. Why is that so?',
		"choices": ["is_dead = true", "die()", "hide()", "show()"],
		"correct_choice": "is_dead = true"
	}
]

var player_defeat= [
	{
		"program": "@onready var player_hp = get_parent().get_node(\"hpBar\")" \
		+ "\n" \
		+ "\nfunc monitor_hp():" \
		+ "\n\tif hp.value > 0:" \
		+ "\n\t\tprint(\"Player is dead!\")",

		
		"problem": 'I am adding to my character script this function that will monitor my HP if it reaches 0. However, it seems that even though it has reached exactly 0, the print statement does not trigger. Why is that?',
		"choices": ["player_hp", "hp.value>0", "get_parent()", "get_node()"],
		"correct_choice": "hp.value>0"
	},

	{
		"program": "@onready var player_hp = get_parent().get_node(\"hpBar\")" \
	+ "\n" \
	+ "\nfunc on_enemy_hits_player(area: Area2D) -> void:" \
	+ "\n\tif area.name == \"hurtbox\":" \
	+ "\n\t\tprint(\"player is damaged\")" \
	+ "\n\t\tplayer_hp.value += 30",
		
		"problem": 'This time, I have improved my function for the enemy to decrease the playerHP by 30 per hit. However, it increases instead, why is that?',
		"choices": ["+= 30", "player_hp.value", "hurtbox", "*30"],
		"correct_choice": "+= 30"
	}
]

var finish= [
	{
		"program": "\n" \
		+ "\nfunc _ready() -> void:" \
		+ "\n\tarea_entered.connect(_on_area_entered)",

		"problem": 'I am almost finished with the sample game, and I am to make a area to enter in order to exit the game. However, there seems to be lacking as there is an error stating "Line 4:Identifier "area_entered" not declared in the current scope.
" What could it possibly be? ',
		"choices": ["extends Control", "extends CharacterBody2D", "extends Node", "extends Area2D"],
		"correct_choice": "extends Area2D"
	},

	{
		"program": "func _on_area_entered(area: Area2D) -> void:" \
		+ "\n\tif area.name == \"hurtbox\":" \
		+ "\n\t\tget_tree()",
		
		"problem": 'The final code function, I just need to quit the game by using a method from the class get_tree(). What should I add?',
		"choices": ["get_parent()", ".get_node()", ".quit()", "_on_area_entered()"],
		"correct_choice": ".quit()"
	}
]

# Sequence of tasks grouped by day
var day_sequences = []

# ================== READY ==================
func _ready():
	day_sequences = [
		[player_defeat, finish],
		[enemy_movement, mob_mechanics],       # Day 2
		 [player_movements, item_mechanics]              # Day 3
	]
	
	# determine today's categories
	var today_index = GlobalConfig.days_left - 1
	if today_index < 0 or today_index >= day_sequences.size():
		print("No programming tasks available for today.")
		return
	
	var today_categories = day_sequences[today_index]
	
	# ensure player hasn't exceeded 2 attempts today
	if GlobalConfig.programmingTasks >= 2:
		print("No more programming tasks allowed today.")
		return
	
	current_category = today_categories[GlobalConfig.programmingTasks]
	quiz_stage = 0
	load_dict(quiz_stage)
	timer.timeout.connect(_on_timer_timeout)
	_update_label()

# ================== LOADING ==================
func load_dict(index: int) -> void:
	if index < current_category.size():
		var dict = current_category[index]
		code.text = dict["program"]
		problem_section.text = dict["problem"]
		generate_choices(dict)
	else:
		# finished this category → evaluate & return to main game
		evaluate_performance()
		GlobalConfig.finished_programming_task = true
		get_tree().change_scene_to_file("res://scenes/game.tscn")

# ================== CHOICE BUTTONS ==================
func generate_choices(dict: Dictionary) -> void:
	for child in choices.get_children():
		child.queue_free()
	for choice in dict["choices"]:
		var btn = Button.new()
		btn.text = choice
		
		# style
		var texture = StyleBoxTexture.new()
		texture.texture = button_bg
		btn.add_theme_stylebox_override("normal", texture)
		btn.add_theme_stylebox_override("hover", texture)
		btn.add_theme_stylebox_override("pressed", texture)
		
		btn.add_theme_font_override("font", button_font)
		btn.add_theme_font_size_override("font_size", 24)
		
		btn.custom_minimum_size = Vector2(200, 60) 
		btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		btn.connect("pressed", Callable(self, "choice_evaluation").bind(choice))
		choices.add_child(btn)

# ================== EVALUATION ==================
func choice_evaluation(choice: String) -> void:
	var dict = current_category.get(quiz_stage)
	if choice == dict["correct_choice"]:
		print("Correct!")
		quiz_stage += 1
		load_dict(quiz_stage)
	else:
		print("Wrong Choice")

# ================== TIMER ==================
func _on_timer_timeout() -> void:
	if total_time > 0:
		total_time -= 1
		_update_label()
	else:
		evaluate_performance()
		timer.stop()
		print("Time's up!")
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _update_label() -> void:
	var minutes = total_time / 60
	var seconds = total_time % 60
	timer_label.text = "Time Left: " + str(minutes) + ":" + str(seconds).pad_zeros(2)

# ================== PERFORMANCE ==================
func evaluate_performance() -> void:
	GlobalConfig.programmingTasks += 1
	
	var consumed_time = 120 - total_time
	if consumed_time <= 60:
		GlobalConfig.current_time += 1
	elif consumed_time <= 120:
		GlobalConfig.current_time += 2

	if GlobalConfig.programmingTasks >= 2:
		print("Player reached max programming attempts for today.")
