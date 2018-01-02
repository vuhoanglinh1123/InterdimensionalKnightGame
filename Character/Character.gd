extends RigidBody2D
##PRELOAD
var StatusArray = preload("res://Environment/ElementalStatus/StatusArray.gd")
var StackFSM = preload("res://Utils/StackFSM.gd")
##EXPORT VAR
export (int) var MAX_RUN_SPEED = 800
export (int) var JUMP_FORCE = 800
export (int) var EXTRA_GRAVITY = 2500
export (int) var ACCERLERATION = 100
export (int) var MAX_HEALTH = 20


var max_run_speed = 0
var jump_force = 0
var extra_gravity = 0
var accerleration = 0
var max_health = 0
##onready
onready var flip = get_node("flip")
onready var ground_detector = get_node("ground_detector")

##Common var
var direction = 1 #direction = -1:left; 1:right
var current_speed = Vector2()

var cur_health = 0

#status resistances
var poison_resis = 0

#states: "ground", "air",...
var state_machine = StackFSM.new(self)

##ELEMENTS_HARMFUL
var status_array = StatusArray.new()


func _ready():
	init_variable()
	#set fixed process
	set_fixed_process(true)
	set_process(true)
	#apply gravity
	set_applied_force(Vector2(0,extra_gravity))
	#set begin health
	cur_health = max_health
	pass

func _integrate_forces(state):
	#call switch state
	flip.set_scale(Vector2(direction,1))
	update_state()
	#call destroyed
	destroyed()
	pass
func _process(delta):
	active_status(delta)
	pass

#inti variable
func init_variable():
	max_run_speed = MAX_RUN_SPEED
	jump_force = JUMP_FORCE
	extra_gravity = EXTRA_GRAVITY
	accerleration = ACCERLERATION
	max_health = MAX_HEALTH
	pass

#ground check
func ground_check():
	if ground_detector.is_colliding():
		var body = ground_detector.get_collider()
		if body.is_in_group("GROUND"):
			return true
	else:
		return false
	pass

##OVERRIDE
#override this for switching state, 
func update_state():
	pass
#
##damaged: Can be extend depend character
#direction: push direction in x-axis
func damaged(damage, direction, push_back_force):
	cur_health -= damage
	set_linear_velocity(Vector2(push_back_force.x*direction, push_back_force.y))
	flip.set_scale(Vector2( direction , 1))
	
	pass

##to apply element
func apply_status(type, duration, level):
	var new_status = Utils.creat_status(type, self, duration, level)
	status_array.add(new_status)
	pass

#make element effect run
func active_status(delta):
	for status in status_array.list:
		status.update()
	pass


##free instance when die
func destroyed():
	if cur_health <= 0:
		queue_free()
	pass

