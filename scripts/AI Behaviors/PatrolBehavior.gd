extends Node

# private var
var body
var time
var time_btw_walks
var time_to_walk
var time_to_acc

func _init(body):
	self.body = body
	first_run()
	pass

func first_run():
	time = 0
	time_btw_walks = 0
	time_to_walk = 0
	time_to_acc  = body.max_velocity / (body.accerleration * 100)
	pass

## BEHAVIOR SCRIPT
# PATROLING
func patrol(delta):
	stepRandomly(delta)
	
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

func stepRandomly(delta):
	time = time + delta
	
	if time > time_to_walk + time_btw_walks:
		time = 0
		randomize()
		time_btw_walks = rand_range(time_to_acc, body.max_time_btw_walks)
		time_to_walk   = rand_range(time_to_acc, body.max_time_to_walk)
		
		# randomize the direction between -1 and 1
		if round(randf()):
			body.direction = 1
		else:
			body.direction = -1
	
	if time < time_to_walk:
		body.speed.x = lerp(body.speed.x, body.max_velocity * body.direction, body.accerleration*0.01) #acc * 0.01, turn into percent
		body.set_linear_velocity(Vector2( body.speed.x, body.get_linear_velocity().y ))
	else:
		body.speed.x = lerp(body.speed.x, 0, body.accerleration*0.01)
		body.set_linear_velocity(Vector2( body.speed.x, body.get_linear_velocity().y ))
	pass