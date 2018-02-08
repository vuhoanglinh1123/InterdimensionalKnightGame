extends "res://Character/Enemy/GroundEnemy/GroundEnemy.gd"

onready var hitbox = flip.get_node("attack/hitbox")

# preload classes
var WanderBehavior  = preload("res://Character/Enemy/GroundEnemy/AIBehaviors/WanderBehavior.gd")
var PursuitBehavior = preload("res://Character/Enemy/GroundEnemy/AIBehaviors/PursuitBehavior.gd")

var user = self
var time = ATTACK_INTERVAL
var obj_attack

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

# Deal damage to PLAYER on contact
func _on_hurtbox_area_enter( area ):
	if area.is_in_group("PLAYER"):
		var damage_dir = sign(target.get_pos().x - get_pos().x)
		target.take_damage(CONTACT_DMG, damage_dir, KNOCKBACK_FORCE)
	pass # replace with function body

## Animation handling
func run_anim():
	current_state = state_machine.get_current_state()
	
	if current_state == STATE.WANDER:
		if WanderBehavior.is_wandering():
			play_loop_anim(STATE.WANDER)
		else:
			idle()
	elif current_state == STATE.PURSUIT:
		play_loop_anim(STATE.PURSUIT)
	elif current_state == STATE.ATTACK:
		anim.stop()
		anim.play(STATE.ATTACK)
	elif current_state == STATE.HURT:
		anim.stop()
		anim.play(STATE.HURT)
	
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
	if attack_dt.is_colliding() and ground_check():
		PursuitBehavior.exit()
		state_machine.push_state(STATE.ATTACK)
	
	pass


# ATTACK STATE -------------------------------------------------------------------------
# ATTACK the PLAYER
func attack():
	time += Utils.fixed_delta
	
	if time >= ATTACK_INTERVAL:
		obj_attack = Attack.new(self)
		switch_attack_func()
		obj_attack.update()
		time = 0
	
	## EXIT
	# ATTACK -> previous STATE
	if not attack_dt.is_colliding() or not ground_check():
		time = ATTACK_INTERVAL
		state_machine.pop_state()
	pass

func switch_attack_func():
	obj_attack.switch_attack_func()
	pass

# HIT STATE -----------------------------------------------------------------------------
# When SELF is take_damage
func hurt():
	if ground_check() and not anim.is_playing():
		state_machine.pop_state()
		state_machine.push_state(STATE.PURSUIT)
	pass

# Inner class that handles attack
class Attack extends "res://Utils/AttackState.gd":
	
	func _init(weapon).(weapon):
		print("attack")
		ANIM_PLAYER = weapon.anim
		HITBOX = weapon.hitbox
		pass
	
	func attack_func():
		USER.run_anim()
		pass
	