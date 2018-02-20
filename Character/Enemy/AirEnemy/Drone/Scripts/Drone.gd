extends "res://Character/Enemy/AirEnemy/AirEnemy.gd"

# STATES
const STATE = { 
	FLYING = "flying",
}

var target_position
var position
var velocity
var desired_velocity
var steering

func _ready():
	state_machine.push_state(STATE.FLYING)
	pass

func flying():
	target_position  = target.get_global_pos()
	position         = get_global_pos()
	velocity         = get_linear_velocity()
	desired_velocity = Vector2(target_position - position).normalized() * MAX_VELOCITY
	steering         = desired_velocity - velocity
	steering         = steering.clamped(TURN_RATE)
#	steering         = steering / steering_force
	velocity         = velocity + steering
	set_linear_velocity(velocity)
	pass