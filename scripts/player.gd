extends RigidBody2D

var input_states = preload("res://scripts/input_states.gd")

##EXPORT VAR
export var run_max_speed = 800
export var jump_force = 800
export var extra_gravity = 2500
export var accerleration = 100
export var max_health = 20

export var atk_max_time = .5
export var atk_thurst_acc = 200
export var atk_thurst_speed = 1000

export var poison_tick = 1

##ONREADY VAR
onready var ground_detector = get_node("ground_detector")
onready var flip = get_node("flip")
onready var hitboxes = flip.get_node("hitboxes")
##VAR
#inputs
var btn_left = input_states.new("btn_left")
var btn_right = input_states.new("btn_right")
var btn_up = input_states.new("btn_up")
var btn_atk1 = input_states.new("btn_atk1")
var btn_atk2 = input_states.new("btn_atk2")

#
var direction = 1 #direction = -1:left; 1:right
var current_speed = Vector2()

#states: "ground", "air",...
var state = ""
var state_next = "air"

#atk_state "slash1", "slash2", "thrust"
var atk_move = ""
var atk_time = 0

#element status "none", "poison"
var element = ""
var element_next = "none"

var element_poison_duration = 0
var element_poison_tick = 0
#stat
var cur_health = 0
##Func
func _ready():
	set_fixed_process(true)
	ground_detector.add_exception(self)
	
	set_applied_force(Vector2(0,extra_gravity))
	
	cur_health = max_health
	pass
	
#ground check
func ground_check():
	if ground_detector.is_colliding():
		var body = ground_detector.get_collider()
		if body.is_in_group("ground"):
			return true
	else:
		return false
	pass
	
#move function
func move(to_speed, acc): 
	current_speed.x = lerp(current_speed.x, to_speed, acc*0.01) #acc * 0.01, turn into percent
	set_linear_velocity(Vector2( current_speed.x, get_linear_velocity().y ))
	pass
	
#jump function
func jump(force):
	set_axis_velocity( Vector2(0,-force) )
	pass
	
####fixed_process
func _fixed_process(delta):
	#element status
	element = element_next
	if element == "none":
		element_none()
	elif element == "poison":
		element_poison(delta) 
	
	#state machine
	state = state_next
	
	if state == "air":
		state_air(delta)
	elif state == "ground":
		state_ground(delta)
	elif state == "atk1_1":
		state_atk1_1(delta)
	elif state == "atk1_2":
		state_atk1_2(delta)
	elif state == "atk2":
		state_atk2(delta)
	#animation
	flip.set_scale(Vector2(direction,1))
	pass

##STATES

#ground
func state_ground(delta):
	#inputs
	if btn_left.check() == 2:
		direction = -1
		move( direction * run_max_speed, accerleration)
	elif btn_right.check() == 2:
		direction = 1
		move( direction * run_max_speed, accerleration)
	else:
		move(0, accerleration)
	#jump	
	if btn_atk1.check() == 1:
		state_next = "atk1_1"
		atk_time = 0
	elif btn_atk2.check() == 1:
		state_next = "atk2"
		atk_time = 0
	elif btn_up.check() == 1:
		jump(jump_force)
	
	#check state
	if !ground_check():
		state_next = "air"
	
	pass
	
#air
func state_air(delta):
	#inputs
	if btn_left.check() == 2:
		direction = -1
		move( direction * run_max_speed, accerleration)
	elif btn_right.check() == 2:
		direction = 1
		move( direction * run_max_speed, accerleration)
	else:
		move(0, accerleration)
	#state
	if ground_check():
		state_next = "ground"
	pass

#atk1_1
func state_atk1_1(delta):
	move(0, accerleration)
	
	if atk_move != "slash1":
		atk_move = "slash1"
		hitboxes.attack(atk_move)
	
	if btn_atk1.check() == 1:
		state_next = "atk1_2"
		atk_time = 0
		
	atk_time += delta
#	#break_condition
	atk_break()
	
	pass
#atk1_2
func state_atk1_2(delta):
	if atk_move != "slash2":
		atk_move = "slash2"
		hitboxes.attack(atk_move)
		
	atk_time += delta
	#break_condition
	atk_break()
	pass
#atk2 thrust only hit one enemy
func state_atk2(delta):
	if atk_move != "thrust":
		atk_move = "thrust"
		hitboxes.attack(atk_move)
	
	#moving
	if atk_time < atk_max_time/4:
		move( direction * atk_thurst_speed, atk_thurst_acc)
	else:
		move(0, accerleration)
		
	atk_time += delta
	#break_condition
	atk_break()
	pass
	
#atk break func
func atk_break():
	if atk_time >= atk_max_time:
		hitboxes.stop_atk()
		state_next = "air"
		atk_move = ""
	pass
#damaged
func damaged(damage, direction, push_back_force):
	cur_health -= damage
	set_linear_velocity(Vector2(push_back_force.x*direction, push_back_force.y))
	flip.set_scale(Vector2( direction , 1))
#	element_next = status
#	
#	if status == "poison":
#		element_poison_duration = status_time
	pass

## ELEMENTS
#normal
func element_none():
	
	pass
#poison
func element_poison(delta):
	
	element_poison_duration -= delta
	element_poison_tick -= delta
	
	if element_poison_tick <= 0:
		cur_health -= 1
		element_poison_tick = poison_tick
	
	if element_poison_duration <= 0:
		element_next = "none" 
	pass
	
#return to none
func return_none():
	
	pass
