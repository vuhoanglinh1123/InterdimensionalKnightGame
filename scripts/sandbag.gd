extends RigidBody2D

#export var
export var max_health = 10
export var extra_gravity = 2500

#onready var
onready var rotate = get_node("rotate")
#var
#states
var direction = 1
var state = ""
var atk_move = ""


#element status "none", "poison"
var element = ""
var element_next = "none"
#stats
var cur_health = 0



##FUNC
func _ready():	
	set_fixed_process(true)
	set_applied_force(Vector2(0,extra_gravity))
	
	cur_health = max_health
	element = element_next
	pass
	
func damaged(damage, direction, push_back_force, status):
	cur_health -= damage
	set_linear_velocity(Vector2(push_back_force.x*direction, push_back_force.y))
	rotate.set_scale(Vector2( direction , 1))
	element_next = status
	pass
##FIXED PROCESS
func _fixed_process(delta):
	
	#death
	if cur_health <= 0:
		queue_free()
	pass

