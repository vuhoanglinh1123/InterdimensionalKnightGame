extends Node2D

export (float) var MAX_WALK_TIME = 5
export (float) var MAX_IDLE_TIME = 2

# private var
var body
var idle_time
var walk_time
var acc_time
var can_walk
var target    # fake target to follow
var target_dir

func _init(body):
	self.body = body
	init_variable()
	pass

func init_variable():
	idle_time = 0
	walk_time = 0
	can_walk  = true
	target_dir = body.direction
	set_target()
	body.wander_timer.connect("timeout", self, "on_timer_timeout")
	body.wander_timer.set_wait_time(0.1)
	body.wander_timer.set_one_shot(true)
	body.wander_timer.start()
	acc_time = 0
	pass

## BEHAVIOR SCRIPT
# PATROLING
func wander():
	body.wander_timer.set_active(true)
	body.direction = target_dir
	
	if body.ground_check():
		# Check for platform edges
		if body.direction > 0 and not body.bound_dt_1.is_colliding():
			target_dir = -body.direction
		elif body.direction < 0 and not body.bound_dt_2.is_colliding():
			target_dir = -body.direction
		
		# Check for vertical walls
		if body.wall_dt.is_colliding():
			var normal = body.wall_dt.get_collision_normal()
			if sign(normal.x * body.direction) < 0:
				target_dir = -body.direction
	
	set_target()
	if can_walk:
		body.move(target, body.MAX_VELOCITY)
		body.play_loop_anim("wander")
	else:
		body.idle()
	pass

func on_timer_timeout():
	randomize()
	if can_walk:
		idle_time = rand_range(acc_time, MAX_IDLE_TIME)
		body.wander_timer.set_wait_time(idle_time)
		can_walk = false
	else:
		walk_time = rand_range(acc_time, MAX_WALK_TIME)
		body.wander_timer.set_wait_time(walk_time)
		# randomize the direction between -1 and 1
		if round(randf()):
			target_dir = 1
		else:
			target_dir = -1
		can_walk = true
	body.wander_timer.start()
	pass

func set_target():
	target = body.get_pos() + Vector2(100, 0) * target_dir
	pass

func exit():
	body.wander_timer.set_active(false)
	pass