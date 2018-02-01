extends RigidBody2D

var StackFSM = preload("res://Utils/StackFSM.gd")

# onready var
onready var flip         = get_node("flip")  # Character
onready var ground_dt    = get_node("ground_detector") # Character
onready var bound_dt_1   = get_node("bound_detector_1")
onready var bound_dt_2   = get_node("bound_detector_2")
onready var wall_dt      = flip.get_node("wall_detector")
onready var player_dt    = flip.get_node("player_detector")
onready var att_dt       = flip.get_node("att_detector")
onready var anim         = flip.get_node("sprite/anim") # Character
onready var target       = Utils.get_main_node().get_node("player")
onready var wander_timer = get_node("wander_timer")

# Collision boxes
onready var hurtbox = get_node("hurtbox")
onready var physics_box = get_node("physics_box")

# Character
# export var
export (bool) var DEBUG_MODE    = false
export (bool) var JUMPABLE      = false
export (int) var MAX_HEALTH     = 10
export (int) var ATK_DMG        = 0
export (int) var CONTACT_DMG    = 0
export (int) var EXTRA_GRAVITY  = 2500
export (int) var MAX_VELOCITY   = 300
export (int) var PURSUIT_VELOCITY = 300
export (int) var JUMP_FORCE     = 1200
export (Vector2) var KNOCKBACK_FORCE = Vector2(0, 0)
export (int) var DETECT_RANGE   = 1200
export (int) var PURSUIT_RANGE  = 1200
export (int) var ATTACK_RANGE   = 200
export (Vector2) var WALK_TIME  = Vector2(1, 6)
export (Vector2) var IDLE_TIME  = Vector2(1, 3)
export (int) var TRACE_AMOUNT   = 10
export var ELEMENT = "none";

# init the StateMachine
var state_machine = StackFSM.new(self)

# Character
# stats
var cur_health = 0
var speed      = Vector2()
var direction  = 1
var current_state = ""
var status = ""

func _ready():
	set_process(true)
	set_fixed_process(true)
	
	ground_dt.add_exception(self)
	wall_dt.add_exception(self)
	bound_dt_1.add_exception(self)
	bound_dt_2.add_exception(self)
	player_dt.add_exception(self)
	att_dt.add_exception(self)
	print("Add Exception Done!")
	
	init_varibles()
	pass

func init_varibles():
	player_dt.set_cast_to(Vector2(DETECT_RANGE, 0))
	att_dt.set_cast_to(Vector2(ATTACK_RANGE, 0))
	
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
		die()
	pass

# FIXED PROCESS
func _fixed_process(delta):
	state_machine.update()
	update()
	pass

# define how SELF moves
func move(target, max_velocity):
	var position = get_pos()
	var velocity = Vector2(target - get_pos()).normalized() * max_velocity
	set_linear_velocity(Vector2(velocity.x, get_linear_velocity().y).floor())
	pass

func is_target_out_of_range(x_range, y_range):
	var length_dist = abs(get_pos().x - target.get_pos().x)
	var height_dist = abs(get_pos().y - target.get_pos().y)
	
	if length_dist >= x_range or height_dist >= y_range:
		return true
	else:
		return false
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

func take_damage(damage, direction, push_back_force):
	cur_health -= damage
	set_linear_velocity(Vector2(push_back_force.x*direction, push_back_force.y))
	self.direction = -direction
	pass

# Handle looped animations
func play_loop_anim(name):
	if anim.get_current_animation() != name:
		anim.play(name)
	pass

# Call this to be idle
func idle():
	move(get_pos(), 0)
	play_loop_anim("idle")
	pass

func die():
	set_process(false)
	set_fixed_process(false)
	hurtbox.queue_free()
	physics_box.queue_free()
	randomize()
	set_linear_velocity(Vector2(-200*direction, -100*floor(rand_range(4,10))))
	anim.play("die")
	yield(anim, "finished")
	print("die")
	queue_free()
	pass