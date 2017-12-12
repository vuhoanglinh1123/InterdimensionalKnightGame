extends "res://scripts/Character.gd"

##import
var input_states = preload("res://scripts/input_states.gd")

#inputs
var btn_left = input_states.new("btn_left")
var btn_right = input_states.new("btn_right")
var btn_up = input_states.new("btn_up")
var btn_atk1 = input_states.new("btn_atk1")
var btn_atk2 = input_states.new("btn_atk2")



func _ready():
	state_next = "air"
	pass

func switchState(delta):
	#state machine
	state = state_next
	
	if state == "air":
		state_air(delta)
	elif state == "ground":
		state_ground(delta)
#	elif state == "atk1_1":
#		state_atk1_1(delta)
#	elif state == "atk1_2":
#		state_atk1_2(delta)
#	elif state == "atk2":
#		state_atk2(delta)
	#animation
	flip.set_scale(Vector2(direction,1))
	pass

##FUNCTION

#move function
func move(to_speed, acc): 
	current_speed.x = lerp(current_speed.x, to_speed, acc*0.01) #acc * 0.01, turn into percent
	set_linear_velocity(Vector2( current_speed.x, get_linear_velocity().y ))
	pass
	
#jump function
func jump(force):
	set_axis_velocity( Vector2(0,-force) )
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
#	if btn_atk1.check() == 1:
#		state_next = "atk1_1"
#		atk_time = 0
#	elif btn_atk2.check() == 1:
#		state_next = "atk2"
#		atk_time = 0
#	elif btn_up.check() == 1:
#		jump(jump_force)
	if btn_up.check() == 1:
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
