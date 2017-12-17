extends Node

export (float) var MAX_WALK_TIME = 5
export (float) var MAX_IDLE_TIME = 2

# private var
var body
var idle_time
var walk_time
var acc_time
var can_walk

func _init(body):
	self.body = body
	init_variable()
	pass

func init_variable():
	idle_time = 0
	walk_time = 0
	can_walk  = true
	body.wander_timer.connect("timeout", self, "on_timer_timeout")
	body.wander_timer.set_wait_time(0.1)
	body.wander_timer.set_one_shot(true)
	body.wander_timer.start()
	acc_time = body.MAX_VELOCITY / (body.ACCELERATION * 100)
	pass

## BEHAVIOR SCRIPT
# PATROLING
func wander():
	walk_randomly()
	
	if body.ground_check():
		# Check for platform edges
		if body.direction > 0 and not body.bound_dt_1.is_colliding():
			body.direction = -body.direction
		elif body.direction < 0 and not body.bound_dt_2.is_colliding():
			body.direction = -body.direction
		
		# Check for vertical walls
		if body.wall_dt.is_colliding():
			var normal = body.wall_dt.get_collision_normal()
			if sign(normal.x * body.direction) < 0:
				body.direction = -body.direction
	pass

func walk_randomly():
	if can_walk:
		body.speed.x = lerp(body.speed.x, body.MAX_VELOCITY * body.direction, body.ACCELERATION*0.01)
	else:
		body.speed.x = lerp(body.speed.x, 0, body.ACCELERATION*0.01)
	
	body.set_linear_velocity(Vector2( body.speed.x, body.get_linear_velocity().y ))
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
		can_walk = true
		# randomize the direction between -1 and 1
		if round(randf()):
			body.direction = 1
		else:
			body.direction = -1
	body.wander_timer.start()
	pass