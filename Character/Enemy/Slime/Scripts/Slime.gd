extends "res://Character/Enemy/Enemy.gd"

# preload classes
var WanderBehavior  = preload("res://Character/Enemy/AI Scripts/Behaviors/WanderBehavior.gd")
var PursuitBehavior = preload("res://Character/Enemy/AI Scripts/Behaviors/PursuitBehavior.gd")
var StackFSM        = preload("res://Character/Enemy/AI Scripts/StackFSM.gd")

# STATES
var STATE_WANDER  = "wander"
var STATE_PURSUIT = "pursuit"
var STATE_ATTACK  = "attack"
var STATE_HURT    = "hurt"

# READY
func _ready():
	set_fixed_process(true)
	WanderBehavior  = WanderBehavior.new(self)
	PursuitBehavior = PursuitBehavior.new(self)
	StackFSM        = StackFSM.new(self)
	StackFSM.push_state(STATE_WANDER)
	update()
	pass

# FIXED PROCESS
func _fixed_process(delta):
	StackFSM.update()
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

func play_anim(name):
	if anim.get_current_animation() != name:
		anim.stop()
		anim.play(name)
	pass

# Call this to be idle
func idle():
	move(get_pos(), 0)
	play_anim("idle")
	pass

# For STATE that needs to be readily accessed at any given time
# Ex: The enemy can take damage (a.k.a switch to HURT state) at any moment
func omnipresent():
	# WHATEVER -> HIT
	if is_hurt:
		StackFSM.push_state(STATE_HURT)
	pass

# WANDER STATE ------------------------------------------------------------------------
# WANDERING and IDLING
func wander():
	WanderBehavior.wander()
	
	## EXIT
	omnipresent()
	
	## EXIT
	# WANDER -> PURSUIT
	if player_dt.is_colliding():
		var body = player_dt.get_collider()
		if body.is_in_group("PLAYER"):
			WanderBehavior.exit()
			StackFSM.pop_state()
			StackFSM.push_state(STATE_PURSUIT)
	
	pass

# PURSUIT STATE -----------------------------------------------------------------------
# PURSUIT the PLAYER when they are detected
func pursuit():
	PursuitBehavior.pursuit()
	
	## EXIT
	omnipresent()
	
	## EXIT
	# PURSUIT -> WANDER
	if PursuitBehavior.is_player_out_of_range():
		PursuitBehavior.exit()
		StackFSM.pop_state()
		StackFSM.push_state(STATE_WANDER)
	
	## EXIT
	# PURSUIT -> ATTACK
	if get_pos().distance_to(target.get_pos()) <= ATTACK_RANGE and ground_check():
		PursuitBehavior.exit()
		StackFSM.push_state(STATE_ATTACK)
	
	pass



# ATTACK STATE -------------------------------------------------------------------------
# ATTACK the PLAYER
func attack():
	idle()
	
	## EXIT
	omnipresent()
	
	## EXIT
	# ATTACK -> previous STATE
	if get_pos().distance_to(target.get_pos()) > ATTACK_RANGE or !ground_check():
		StackFSM.pop_state()
	
	pass


# HIT STATE -----------------------------------------------------------------------------
# When SELF is damaged
func hurt():
#	knocked_back()
	
	if get_linear_velocity().abs() <= Vector2(50,50):
		is_hurt = false
		StackFSM.pop_state()
	pass