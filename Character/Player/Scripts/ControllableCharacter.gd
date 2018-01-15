extends "res://Character/Character.gd"

##import
var input_states = preload("res://Utils/InputStates.gd")

##CONST
const STATE = {
	GROUND = "state_ground",
	AIR = "state_air",
	ATK1 = "state_atk1",
	ATK2 = "state_atk2",
	HURT = "state_hurt"
}

#inputs
var btn_left = input_states.new("btn_left")
var btn_right = input_states.new("btn_right")
var btn_up = input_states.new("btn_up")
var btn_atk1 = input_states.new("btn_atk1")
var btn_atk2 = input_states.new("btn_atk2")

#weapon
onready var weapon = flip.get_node("hitboxes")


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
		state_machine.push_state(STATE.ATK1)
		weapon.atk1()

	
	#check state
	if !ground_check():
		state_machine.pop_state()
		state_machine.push_state(STATE.AIR)
	pass
	
#air
func state_air():
	#inputs
	if btn_left.check() == 2:
		direction = -1
		move( direction * max_run_speed, accerleration)
	elif btn_right.check() == 2:
		direction = 1
		move( direction * max_run_speed, accerleration)
	else:
		move(0, accerleration)
	#state
	if ground_check():
		state_machine.pop_state()
		state_machine.push_state(STATE.GROUND)
	pass

#atk1
func state_atk1():
	weapon.state_atk1()
	pass

#state hurt
func state_hurt():
	
	if ground_check():
		state_machine.pop_state()
		state_machine.push_state(STATE.GROUND)
	ground_detector.set_enabled(true)
	pass