extends RigidBody2D

##EXPORT VAR
export var run_max_speed = 800
export var jump_force = 1200
export var extra_gravity = 2500
export var accerleration = 100
export var max_health = 20

##onready
onready var flip = get_node("flip")
onready var ground_detector = get_node("ground_detector")

##Common var
var direction = 1 #direction = -1:left; 1:right
var current_speed = Vector2()

var cur_health = 0

#states: "ground", "air",...
var state = ""
var state_next = ""



func _ready():
	#set fixed process
	set_fixed_process(true)
	#apply gravity
	add_force(Vector2(0,0),Vector2(0,extra_gravity))
	#set begin health
	cur_health = max_health
	pass

func _fixed_process(delta):
	
	#call switch state
	switchState(delta)
	#call destroyed
	destroyed()
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
func switchState(delta):
	
	pass

#
##damaged: Can be extend depend character
#direction: push direction in x-axis
func damaged(damage, direction, push_back_force):
	cur_health -= damage
	set_linear_velocity(Vector2(push_back_force * direction, 0))
	flip.set_scale(Vector2( direction , 1))
	pass

##to apply element
#func applyElement(status, status_time):
#	element_next = status
#	
#	if status == "poison":
#		element_poison_duration = status_time
#	pass

##free instance when die
func destroyed():
	if cur_health <= 0:
		queue_free()
	pass

