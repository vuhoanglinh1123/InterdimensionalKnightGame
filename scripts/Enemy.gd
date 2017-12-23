extends RigidBody2D

# onready var
onready var flip        = get_node("flip")  # Character
onready var ground_dt   = get_node("ground_detector") # Character
onready var bound_dt_1  = get_node("bound_detector_1") # Character
onready var bound_dt_2  = get_node("bound_detector_2") # Character
onready var wall_dt     = get_node("flip/wall_detector") # Character
onready var anim        = get_node("flip/Sprite/anim") # Character
onready var player_dt   = get_node("flip/player_detector")
onready var target      = Utils.get_main_node().get_node("player")

# Character
# export var
export var max_health         = 10
export var extra_gravity      = 2500
export var accerleration      = 100
export var max_velocity       = 300
export var jump_force         = 800
export var max_time_to_walk   = 5
export var max_time_btw_walks = 2

# Character
# stats
var cur_health = 0
var speed          = Vector2()
var direction      = 1

func _ready():
	set_process(true)
	
	ground_dt.add_exception(self)
	wall_dt.add_exception(self)
	bound_dt_1.add_exception(self)
	bound_dt_2.add_exception(self)
	player_dt.add_exception(self)
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