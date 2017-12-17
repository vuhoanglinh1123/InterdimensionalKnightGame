extends "res://scripts/Enemy.gd"

# preload classes
var WanderBehavior  = preload("res://scripts/AI Behaviors/WanderBehavior.gd")
var PursuitBehavior = preload("res://scripts/AI Behaviors/PursuitBehavior.gd")
var StackFSM        = preload("res://scripts/StackFSM.gd")

# states
var STATE_WANDER  = "wander"
var STATE_PURSUIT = "pursuit"
var STATE_ATTACK  = "attack"
var STATE_HIT     = "hit"

# READY
func _ready():
	set_fixed_process(true)
	WanderBehavior  = WanderBehavior.new(self)
	PursuitBehavior = PursuitBehavior.new(self)
	StackFSM        = StackFSM.new(self)
	StackFSM.push_state(STATE_WANDER)
	pass

# FIXED PROCESS
func _fixed_process(delta):
	StackFSM.update()
	pass

func get_current_state():
	return StackFSM.get_current_state()
	pass

#func state_anim():
#	if state == STATE_WANDER:
#		anim.play("walk")
#	elif state == STATE_PURSUIT:
#		state = STATE_PURSUIT
#	elif state == STATE_ATTACK:
#		state = STATE_ATTACK
#	elif state == STATE_HIT:
#		state = STATE_HIT
#	pass

# WANDER STATE ------------------------------------------------------------------------
# WANDERING and IDLING
func wander():
	WanderBehavior.wander()
	
	## EXIT
	# WANDER -> PURSUIT
	if player_dt.is_colliding():
		var body = player_dt.get_collider()
		if body.is_in_group("PLAYER"):
			StackFSM.pop_state()
			StackFSM.push_state(STATE_PURSUIT)
	pass

# PURSUIT STATE -----------------------------------------------------------------------
# PURSUIT the PLAYER when they are detected
func pursuit():
	PursuitBehavior.pursuit()
	
	## EXIT
	# PURSUIT -> WANDER
	if PursuitBehavior.is_player_out_of_range():
		StackFSM.pop_state()
		StackFSM.push_state(STATE_WANDER)
	pass

## EXIT
# PURSUIT -> ATTACK
func _on_attack_range_body_enter( body ):
	if body.is_in_group("PLAYER"):
		StackFSM.push_state(STATE_ATTACK)
	pass # replace with function body

# ATTACK STATE -------------------------------------------------------------------------
# ATTACK the PLAYER
func attack():
	
	pass

## EXIT
# ATTACK -> previous STATE
func _on_attack_range_body_exit( body ):
	if body.is_in_group("PLAYER"):
		StackFSM.pop_state()
	pass # replace with function body

# HIT STATE -----------------------------------------------------------------------------
# When SELF is damaged
func hit():
	
	pass