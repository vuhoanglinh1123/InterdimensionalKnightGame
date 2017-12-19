extends "res://scripts/Enemy.gd"

# preload classes
var WanderBehavior  = preload("res://scripts/AI Behaviors/WanderBehavior.gd")
var PursuitBehavior = preload("res://scripts/AI Behaviors/PursuitBehavior.gd")
var StackFSM        = preload("res://scripts/StackFSM.gd")

# STATES
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
	update()
	pass

# FIXED PROCESS
func _fixed_process(delta):
	StackFSM.update()
	update()
	pass

func get_current_state():
	return StackFSM.get_current_state()
	pass

func play_anim(name):
	if anim.get_current_animation() != name:
		anim.stop()
		anim.play(name)
	pass

func _draw():
	draw_circle(Vector2(0,0), PURSUIT_RANGE, Color(0, 1, 0, 0.1))
	var prev_item = get_pos()
	for item in PursuitBehavior.traces:
		draw_line(prev_item-get_pos(), item-get_pos(), Color(0,0,1), 2)
		draw_circle(item-get_pos(), 10, Color(0,0,1))
		prev_item = item
	pass

# WANDER STATE ------------------------------------------------------------------------
# WANDERING and IDLING
func wander():
	WanderBehavior.wander()
	if get_linear_velocity() == Vector2(0,0):
		play_anim("idle")
	else:
		play_anim("wander")
	
	## EXIT
	# WANDER -> PURSUIT
	if player_dt.is_colliding():
		var body = player_dt.get_collider()
		if body.is_in_group("PLAYER"):
			WanderBehavior.exit()
			StackFSM.pop_state()
			StackFSM.push_state(STATE_PURSUIT)
	
	if got_hit:
		StackFSM.push_state(STATE_HIT)
	pass

# PURSUIT STATE -----------------------------------------------------------------------
# PURSUIT the PLAYER when they are detected
func pursuit():
	PursuitBehavior.pursuit()
	
	## EXIT
	# PURSUIT -> WANDER
	if PursuitBehavior.is_player_out_of_range():
		PursuitBehavior.exit()
		StackFSM.pop_state()
		StackFSM.push_state(STATE_WANDER)
	
	## EXIT
	# PURSUIT -> ATTACK
	if get_pos().distance_to(target.get_pos()) <= ATTACK_RANGE:
		PursuitBehavior.exit()
		StackFSM.push_state(STATE_ATTACK)
	
	if got_hit:
		StackFSM.push_state(STATE_HIT)
	pass



# ATTACK STATE -------------------------------------------------------------------------
# ATTACK the PLAYER
func attack():
	move(get_pos(), 0)
	
	## EXIT
	# ATTACK -> previous STATE
	if get_pos().distance_to(target.get_pos()) > ATTACK_RANGE:
		StackFSM.pop_state()
	
	if got_hit:
		StackFSM.push_state(STATE_HIT)
	pass


# HIT STATE -----------------------------------------------------------------------------
# When SELF is damaged
func hit():
	knocked_back()
	
	if get_linear_velocity().abs() <= Vector2(50,50):
		got_hit = false
		StackFSM.pop_state()
	pass