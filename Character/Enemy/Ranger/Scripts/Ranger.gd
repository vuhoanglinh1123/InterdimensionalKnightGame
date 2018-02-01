extends "res://Character/Enemy/Enemy.gd"

# preload classes
var WanderBehavior  = preload("res://Character/Enemy/AI Scripts/Behaviors/WanderBehavior.gd")
var PursuitBehavior = preload("res://Character/Enemy/AI Scripts/Behaviors/PursuitBehavior.gd")
var ArrowScene      = load("res://Character/Enemy/Ranger/arrow.tscn")

# STATES
const STATE = { 
	WANDER = "wander",
	PURSUIT = "pursuit",
	ATTACK = "attack",
	HURT = "hurt"
}

# READY
func _ready():
	WanderBehavior  = WanderBehavior.new(self)
	PursuitBehavior = PursuitBehavior.new(self)
	state_machine.push_state(STATE.WANDER)
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

# Override
# Take damage when being attacked
func take_damage(damage, direction, push_back_force):
	.take_damage(damage, direction, push_back_force)
	state_machine.pop_state()
	state_machine.push_state(STATE.HURT)
	run_anim()
	pass

## Animation handling
func run_anim():
	current_state = state_machine.get_current_state()
	
	if current_state == STATE.WANDER:
		if WanderBehavior.is_wandering():
			play_loop_anim("wander")
		else:
			idle()
	elif current_state == STATE.PURSUIT:
		play_loop_anim("pursuit")
	elif current_state == STATE.HURT:
		anim.stop()
		anim.play("hurt")
	
	pass

# WANDER STATE ------------------------------------------------------------------------
# WANDERING and IDLING
func wander():
	WanderBehavior.wander()
	run_anim()
	
	## EXIT
	# WANDER -> PURSUIT
	if player_dt.is_colliding():
		WanderBehavior.exit()
		state_machine.pop_state()
		state_machine.push_state(STATE.PURSUIT)
	
	pass


# PURSUIT STATE -----------------------------------------------------------------------
# PURSUIT the PLAYER when they are detected
func pursuit():
	PursuitBehavior.pursuit()
	run_anim()
	
	## EXIT
	# PURSUIT -> WANDER
	if is_target_out_of_range(PURSUIT_RANGE, OS.get_window_size().y):
		PursuitBehavior.exit()
		state_machine.pop_state()
		state_machine.push_state(STATE.WANDER)
	
	## EXIT
	# PURSUIT -> ATTACK
	if att_dt.is_colliding() and ground_check():
		PursuitBehavior.exit()
		state_machine.push_state(STATE.ATTACK)
	
	pass

var n = 0
var arrow
# ATTACK STATE -------------------------------------------------------------------------
# ATTACK the PLAYER
func attack():
	run_anim()
	play_loop_anim("attack")
	if n < 1:
		arrow = ArrowScene.instance()
		arrow.set_pos(get_global_pos())
		get_tree().get_root().add_child(arrow)
		n += 1
	
	direction = sign(target.get_pos().x - get_pos().x)
	
	## EXIT
	# ATTACK -> previous STATE
	if is_target_out_of_range(DETECT_RANGE, 300) or not ground_check():
		state_machine.pop_state()
	pass

# HIT STATE -----------------------------------------------------------------------------
# When SELF is take_damage
func hurt():
	if ground_check() and not anim.is_playing():
		state_machine.pop_state()
		state_machine.push_state(STATE.PURSUIT)
	pass

