extends "res://Character/Character.gd"

##import
var input_states = preload("res://Utils/InputStates.gd")

##CONST
const STATE = {
	GROUND = "state_ground",
	AIR = "state_air",
	ATKING = "state_attacking",
	HURT = "state_hurt"
}

#inputs
var btn_left = input_states.new("btn_left")
var btn_right = input_states.new("btn_right")
var btn_up = input_states.new("btn_up")
var btn_atk1 = input_states.new("btn_atk1")
var btn_atk2 = input_states.new("btn_atk2")

#weapon
onready var weapon = flip.get_node("DefaultSword")

#air atk already or not
var is_air_atk = false

func _ready():
	state_machine.push_state(STATE.AIR)
	pass

func update_state():
	state_machine.update()
	pass

##ovrride take_damage
func take_damage(damage, direction, push_back_force):
	.take_damage(damage, direction, push_back_force)
	state_machine.pop_state()
	state_machine.push_state(STATE.HURT)
	ground_detector.set_enabled(false)
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
func state_ground():
	#inputs
	if btn_left.check() == 2:
		direction = -1
		move( direction * max_run_speed, accerleration)
	elif btn_right.check() == 2:
		direction = 1
		move( direction * max_run_speed, accerleration)
	else:
		move(0, accerleration)
	
	#press
	if btn_up.check() == 1:
		jump(jump_force)
	elif btn_atk1.check() == 1:
		state_machine.push_state(STATE.ATKING)
		weapon.state_atk1_init()
	elif btn_atk2.check() == 1:
		state_machine.push_state(STATE.ATKING)
		weapon.state_atk2_init()

	#check state
	if !ground_check():
		state_machine.pop_state()
		state_machine.push_state(STATE.AIR)
		is_air_atk = true
	pass

#air
func state_air():
	#inputs
	#movement
	if btn_left.check() == 2:
		direction = -1
		move( direction * max_run_speed, accerleration/10)
	elif btn_right.check() == 2:
		direction = 1
		move( direction * max_run_speed, accerleration/10)
	else:
		move(0, accerleration)
	#atk1
	if btn_atk1.check() == 1 && is_air_atk:
		state_machine.push_state(STATE.ATKING)
		weapon.state_atk1_air_init()
		is_air_atk = false
		pass
	elif btn_atk2.check() == 1 && is_air_atk:
		state_machine.push_state(STATE.ATKING)
		weapon.state_atk2_air_init()
		is_air_atk = false
		pass
	#state
	if ground_check():
		state_machine.pop_state()
		state_machine.push_state(STATE.GROUND)
	pass

#state attacking
func state_attacking():
	weapon.update()
	pass

#state hurt
func state_hurt():
	
	if ground_check():
		state_machine.pop_state()
		state_machine.push_state(STATE.GROUND)
	ground_detector.set_enabled(true)
	pass