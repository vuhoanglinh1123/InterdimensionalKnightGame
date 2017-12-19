extends RigidBody2D

# onready var
onready var flip        = get_node("flip")  # Character
onready var ground_dt   = get_node("ground_detector") # Character
onready var bound_dt_1  = get_node("bound_detector_1")
onready var bound_dt_2  = get_node("bound_detector_2")
onready var wall_dt     = flip.get_node("wall_detector")
onready var player_dt   = flip.get_node("player_detector")
onready var anim        = flip.get_node("Sprite/anim") # Character
onready var target      = Utils.get_main_node().get_node("player")
onready var wander_timer = get_node("wander_timer")

# Character
# export var
export (int) var MAX_HEALTH     = 10
export (int) var EXTRA_GRAVITY  = 2500
export (int) var ACCELERATION   = 100
export (int) var MAX_VELOCITY   = 300
export (int) var JUMP_FORCE     = 800
export (int) var PURSUIT_RANGE  = 1200
export (int) var CHASE_VELOCITY = 300
export (int) var ATTACK_RANGE   = 200

# Character
# stats
var cur_health = 0
var speed      = Vector2()
var direction  = 1
var got_hit    = false 

func _ready():
	set_process(true)
	
	ground_dt.add_exception(self)
	wall_dt.add_exception(self)
	bound_dt_1.add_exception(self)
	bound_dt_2.add_exception(self)
	player_dt.add_exception(self)
	print("Add Exception Done!")
	
	# Character
	set_applied_force(Vector2(0, EXTRA_GRAVITY))
	cur_health = MAX_HEALTH
	pass

# Character
func _process(delta):
	# flip the sprite
	flip.set_scale(Vector2(direction, 1))
	
	# death
	if cur_health <= 0:
		queue_free()
	pass

# define how SELF moves
func move(target, max_velocity):
	var position = get_pos()
	var velocity = Vector2(target - get_pos()).normalized() * max_velocity
	set_linear_velocity(Vector2(velocity.x, get_linear_velocity().y).floor())
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
var dir
var push_force

# Character
func damaged(damage, direction, push_back_force):
	got_hit = true
	cur_health -= damage
	dir = -direction
	push_force = push_back_force * direction + get_pos()
	set_axis_velocity(Vector2(0,push_back_force.y))
	pass

func knocked_back():
	move(push_force, push_force.x)
	direction = dir
	pass