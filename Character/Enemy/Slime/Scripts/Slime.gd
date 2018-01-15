extends "res://Character/Enemy/Enemy.gd"

# preload classes
var WanderBehavior  = preload("res://Character/Enemy/AI Scripts/Behaviors/WanderBehavior.gd")
var PursuitBehavior = preload("res://Character/Enemy/AI Scripts/Behaviors/PursuitBehavior.gd")

# STATES
const STATE = { 
	WANDER = "wander",
	PURSUIT = "pursuit",
	ATTACK = "attack",
	HURT = "hurt"
}

# READY
func _ready():
	set_fixed_process(true)
	WanderBehavior  = WanderBehavior.new(self)
	PursuitBehavior = PursuitBehavior.new(self)
	state_machine.push_state(STATE.WANDER)
	pass

# FIXED PROCESS
func _fixed_process(delta):
	state_machine.update()
	update()
	pass

func _draw():
	if DEBUG_MODE:
		draw_circle(Vector2(0,0), PURSUIT_RANGE, Color(0, 1, 0, 0.1))
		var prev_item = get_pos()
		for item in PursuitBehavior.traces:
			draw_line(prev_item-get_pos(), item-get_pos(), Color(0,0,1), 2)
			draw_circle(item-get_pos(), 10, Color(0,0,1))
			prev_item = item
	pass

# Call this to be idle
func idle():
	move(get_pos(), 0)
	play_loop_anim("idle")
	pass

# Override
func damaged(damage, direction, push_back_force):
	.damaged(damage, direction, push_back_force)
	state_machine.pop_state()
	state_machine.push_state(STATE.HURT)
	anim.play("hurt")
	pass


# WANDER STATE ------------------------------------------------------------------------
# WANDERING and IDLING
func wander():
	WanderBehavior.wander()
	
	## EXIT
	# WANDER -> PURSUIT
	if player_dt.is_colliding():
		var body = player_dt.get_collider()
		if body.is_in_group("PLAYER"):
			WanderBehavior.exit()
			state_machine.pop_state()
			state_machine.push_state(STATE.PURSUIT)
	
	pass

# PURSUIT STATE -----------------------------------------------------------------------
# PURSUIT the PLAYER when they are detected
func pursuit():
	PursuitBehavior.pursuit()
	
	## EXIT
	# PURSUIT -> WANDER
	if PursuitBehavior.is_player_out_of_range():
		PursuitBehavior.exit()
		state_machine.pop_state()
		state_machine.push_state(STATE.WANDER)
	
	## EXIT
	# PURSUIT -> ATTACK
	if get_pos().distance_to(target.get_pos()) <= ATTACK_RANGE and ground_check():
		PursuitBehavior.exit()
		state_machine.push_state(STATE.ATTACK)
	
	pass



# ATTACK STATE -------------------------------------------------------------------------
# ATTACK the PLAYER
func attack():
	idle()
	
	## EXIT
	# ATTACK -> previous STATE
	if get_pos().distance_to(target.get_pos()) > ATTACK_RANGE or !ground_check():
		state_machine.pop_state()
	pass


# HIT STATE -----------------------------------------------------------------------------
# When SELF is damaged
func hurt():
	if ground_check() and not anim.is_playing():
		state_machine.pop_state()
		state_machine.push_state(STATE.PURSUIT)
	pass