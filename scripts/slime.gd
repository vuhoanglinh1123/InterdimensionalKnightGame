extends "res://scripts/Enemy.gd"

# preload classes
var PatrolBehavior  = preload("res://scripts/AI Behaviors/PatrolBehavior.gd")
var PursuitBehavior = preload("res://scripts/AI Behaviors/PursuitBehavior.gd")

# states
var STATE_PATROL  = "Patrol"
var STATE_PURSUIT = "Pursuit"
var STATE_ATTACK  = "Attack"
var STATE_HIT     = "Hit"

var prev_state
var state
var next_state = STATE_PATROL
var atk_move   = "" 

# READY
func _ready():
	set_fixed_process(true)
	PatrolBehavior  = PatrolBehavior.new(self)
	PursuitBehavior = PursuitBehavior.new(self)
	pass

# FIXED PROCESS
func _fixed_process(delta):
	prev_state = state
	state      = next_state
	stateSwitching(delta)
	pass

func stateSwitching(delta):
	if state == STATE_PATROL:
		patrolState(delta)
	elif state == STATE_PURSUIT:
		pursuitState(delta)
	elif state == STATE_ATTACK:
		attackState(delta)
	elif state == STATE_HIT:
		hitState(delta)
	pass

func stateExiting():
	anim.stop_all()
	
	if state == STATE_PATROL:
		state = STATE_PATROL
	elif state == STATE_PURSUIT:
		state = STATE_PURSUIT
	elif state == STATE_ATTACK:
		state = STATE_ATTACK
	elif state == STATE_HIT:
		state = STATE_HIT
	pass

func statePlayAnim():
	if not anim.is_playing():
		if state == STATE_PATROL:
			if speed == Vector2(0, 0):
				anim.play("idle")
			else:
				anim.play("walk")
		elif state == STATE_PURSUIT:
			anim.play("walk")
		elif state == STATE_ATTACK:
			state = STATE_ATTACK
		elif state == STATE_HIT:
			state = STATE_HIT
	pass



## FINITE STATE MACHINE

# PATROL STATE ------------------------------------------------------------------------
# PATROLING and IDLING
func patrolState(delta):
	PatrolBehavior.patrol(delta)
	
	## EXIT
	# PATROL -> PURSUIT
	if player_dt.is_colliding():
		var body = player_dt.get_collider()
		if body.is_in_group("PLAYER"):
			stateExiting()
			next_state = STATE_PURSUIT
	pass

# PURSUIT STATE -----------------------------------------------------------------------
# PURSUIT the PLAYER when they are detected
func pursuitState(delta):
	PursuitBehavior.pursuit()
	
	## EXIT
	# PURSUIT -> PATROL
	if PursuitBehavior.is_player_out_of_range():
		stateExiting()
		next_state = STATE_PATROL
	pass

## EXIT
# PURSUIT -> ATTACK
func _on_attack_range_body_enter( body ):
	if body.is_in_group("PLAYER") and prev_state == STATE_PURSUIT:
		stateExiting()
		next_state = STATE_ATTACK
	pass # replace with function body

# ATTACK STATE -------------------------------------------------------------------------
# ATTACK the PLAYER
func attackState(delta):
	
	pass

## EXIT
# ATTACK -> PURSUIT
func _on_attack_range_body_exit( body ):
	if body.is_in_group("PLAYER") and prev_state == STATE_PURSUIT or prev_state == STATE_ATTACK:
		stateExiting()
		next_state = STATE_PURSUIT
	pass # replace with function body

# HIT STATE -----------------------------------------------------------------------------
# When SELF is damaged
func hitState(delta):
	
	pass