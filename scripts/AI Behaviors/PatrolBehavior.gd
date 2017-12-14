extends RigidBody2D

# onready var
onready var flip        = get_node("flip")  # Character
onready var ground_dt   = get_node("ground_detector") # Character
onready var bound_dt_1  = get_node("bound_detector_1") # Character
onready var bound_dt_2  = get_node("bound_detector_2") # Character
onready var wall_dt     = get_node("flip/wall_detector") # Character
onready var anim        = get_node("flip/Sprite/anim") # Character

# Character
# export var
export var max_health         = 10
export var extra_gravity      = 2500
export var accerleration      = 100
export var max_velocity       = 300
export var jump_force         = 800
export var max_time_to_walk   = 5
export var max_time_btw_walks = 2

# private var
var speed          = Vector2()
var direction      = 1
var time           = 0
var time_btw_walks = 0
var time_to_walk   = 0
var time_to_acc    = max_velocity / (accerleration * 100)

# Character
# stats
var cur_health = 0

func _ready():
	set_process(true)
	ground_dt.add_exception(self)
	wall_dt.add_exception(self)
	bound_dt_1.add_exception(self)
	bound_dt_2.add_exception(self)
	print("Add Exception Done!")
	
	# Character
	set_applied_force(Vector2(0, extra_gravity))
	cur_health = max_health
	pass

# Character
func _process(delta):
	# flip the sprite
	flip.set_scale(Vector2(direction, 1))
	
	# death
	if cur_health <= 0:
		queue_free()
	pass

# Character
# Check for the ground
func ground_check():
	if ground_dt.is_colliding():
		var body = ground_dt.get_collider()
		if body.is_in_group("GROUND"):
			return true
	else:
		return false
	pass

# Character
func damaged(damage, direction, push_back_force, status):
	cur_health -= damage
	set_linear_velocity(Vector2(push_back_force.x*direction, push_back_force.y))
	flip.set_scale(Vector2( direction , 1))
	pass

## BEHAVIOR SCRIPT
func patrolBehavior(delta):
	patrol(delta)
	
	if ground_check():
		# Check for platform edges
		if direction > 0 and not bound_dt_1.is_colliding():
			direction = -direction
		elif direction < 0 and not bound_dt_2.is_colliding():
			direction = -direction
		
		# Check for vertical walls
		if wall_dt.is_colliding():
			var normal = wall_dt.get_collision_normal()
			if sign(normal.x * direction) < 0:
				direction = -direction
	pass

# PATROLING
func patrol(delta):
	time += delta
	
	if time > time_to_walk + time_btw_walks:
		time = 0
		randomize()
		time_btw_walks = rand_range(time_to_acc, max_time_btw_walks)
		time_to_walk   = rand_range(time_to_acc, max_time_to_walk)
		
		# randomize the direction between -1 and 1
		if round(randf()):
			direction = 1
		else:
			direction = -1
	
	if time < time_to_walk:
		speed.x = lerp(speed.x, max_velocity * direction, accerleration*0.01) #acc * 0.01, turn into percent
		set_linear_velocity(Vector2( speed.x, get_linear_velocity().y ))
	else:
		stopMovement()
	pass

# STOPPING
func stopMovement():
	speed.x = lerp(speed.x, 0, accerleration*0.01)
	set_linear_velocity(Vector2( speed.x, get_linear_velocity().y ))
	pass
