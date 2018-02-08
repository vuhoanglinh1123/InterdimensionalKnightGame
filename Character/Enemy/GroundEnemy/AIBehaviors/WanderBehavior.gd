# private var
var body
var can_walk
var target    # fake target to follow
var target_dir
var is_moving = false

func _init(body):
	self.body = body
	init_variable()
	pass

func init_variable():
	can_walk  = true
	target_dir = body.direction
	set_target()
	body.wander_timer.connect("timeout", self, "on_timer_timeout")
	body.wander_timer.set_wait_time(0.1)
	body.wander_timer.set_one_shot(true)
	body.wander_timer.start()
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
		is_moving = true
	else:
		is_moving = false
	pass

func on_timer_timeout():
	randomize()
	if can_walk:
		var idle_time = rand_range(body.IDLE_TIME.x, body.IDLE_TIME.y)
		body.wander_timer.set_wait_time(idle_time)
		can_walk = false
	else:
		var walk_time = rand_range(body.WALK_TIME.x, body.WALK_TIME.y)
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

func is_wandering():
	return is_moving
	pass

func exit():
	body.wander_timer.set_active(false)
	pass