extends Node2D

onready var rotate = get_parent()
onready var slash1 = get_node("slash1")
onready var slash2 = get_node("slash2")
onready var thrust = get_node("thrust")

export var damage = 0
export var push_back_force = Vector2()
export var status = "none"

var direction = 1 

func _ready():
	set_fixed_process(true)
	pass

#call by player to move hitbox to active layer = 2
func attack(atk_type):

	if atk_type == "slash1":
		slash1.set_collision_mask(2)
	elif atk_type == "slash2":
		slash2.set_collision_mask(2)
	elif atk_type == "thrust":
		thrust.set_collision_mask(2)
	pass
#return all hitbox back to rest layer = 20
func stop_atk():
	slash1.set_collision_mask(20)
	slash2.set_collision_mask(20)
	thrust.set_collision_mask(20)
	slash1.set_collision_mask(20)
	slash2.set_collision_mask(20)
	thrust.set_collision_mask(20)
	
	pass

func _on_slash1_area_enter( area ):
	if area.is_in_group("enermy_hurtbox"):
		direction = rotate.get_scale().x
		area.get_parent().damaged(damage, direction,push_back_force, status)
		pass
	pass # replace with function body


func _on_slash2_area_enter( area ):
	if area.is_in_group("enermy_hurtbox"):	
		direction = rotate.get_scale().x
		area.get_parent().damaged(damage*2, direction, push_back_force*1.5, status)
	pass # replace with function body


func _on_thrust_area_enter( area ):
	if area.is_in_group("enermy_hurtbox"):
		direction = rotate.get_scale().x
		area.get_parent().damaged(damage, direction,push_back_force*1.75, status)
		stop_atk()
	pass # replace with function body
