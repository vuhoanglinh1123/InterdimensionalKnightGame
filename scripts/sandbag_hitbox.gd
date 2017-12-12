extends Node2D

onready var rotate = get_parent()
onready var touch_body = get_node("touch_body")

export var damage = 0
export var push_back_force = Vector2()
export var status = "none"
export var poison_time = 5

var direction = 1 

func _ready():

	pass


func _on_touch_body_area_enter( area ):
	if area.is_in_group("player_hurtbox"):
		status = "poison"
		direction = area.get_parent().direction
		push_back_force = area.get_parent().get_linear_velocity()
		area.get_parent().damaged(damage, direction, push_back_force, status, poison_time)
	pass # replace with function body
