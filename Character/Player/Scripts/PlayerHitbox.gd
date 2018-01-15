extends Node2D


onready var flip = get_parent()
onready var user = flip.get_parent()
onready var slash1 = get_node("slash1")
onready var slash2 = get_node("slash2")
onready var thrust = get_node("thrust")

export var damage = 0
export var push_back_force = Vector2()
export var status = "none"
export var atk_1_combo_time_max = 0.3
export var atk_1_end_combo_time_max = 0.5

var direction = 1
var atk_1_combo_time = 0 
var atk1_combo = 0
var atk_time = 0
var atking = 0

func _ready():
	set_fixed_process(true)
	
	slash1.set_collision_mask(2)
	slash2.set_collision_mask(2)
	
	slash1.set_enable_monitoring(false)
	slash2.set_enable_monitoring(false)
	pass

func _fixed_process(delta):
	if atking == 1:
		if atk_time > 0:
			atk_time -= delta
		else:
			turnOffHitbox()
		if atk_1_combo_time > 0:
			atk_1_combo_time -= delta
		else:
			atk1_combo = 0
			stopAtking()
	pass

#decide what can you do in this state
func state_atk1():
	if user.btn_atk1.check() == 1:
		atk1()
	pass

func atk1():
	if atk_1_combo_time > 0:
		if atk1_combo == 1:
			atk1_2()
			atk_1_combo_time = atk_1_combo_time_max
			atk1_combo += 1
#		elif atk1_combo == 2:
#			atk1_3()
#			atk_1_combo_time = atk_1_end_combo_time_max
	else:
		atk1_1()
		atking = 1
		atk_1_combo_time = atk_1_combo_time_max
		atk1_combo += 1
	
	pass

func atk1_1():
	user.move(0, user.accerleration)
	atk_time = atk_1_end_combo_time_max/2
	slash1.set_enable_monitoring(true)
	pass

func atk1_2():
	user.move(0, user.accerleration)
	atk_time = atk_1_end_combo_time_max/2
	slash2.set_enable_monitoring(true)
	pass
#
#func atk1_3():
#	user.move(0, user.accerleration)
#	atk_time = atk_1_end_combo_time_max/2
#	slash2.set_enable_monitoring(true)
#	pass

func turnOffHitbox():
	slash1.set_enable_monitoring(false)
	slash2.set_enable_monitoring(false)
	thrust.set_enable_monitoring(false)
	pass

func stopAtking():
	atking = 0
	user.state_machine.pop_state()
	pass

func _on_slash1_area_enter( area ):
	if area.is_in_group("enermy_hurtbox"):
		direction = flip.get_scale().x
		area.get_parent().take_damage(damage, direction,push_back_force)
	pass # replace with function body


func _on_slash2_area_enter( area ):
	if area.is_in_group("enermy_hurtbox"):
		direction = flip.get_scale().x
		area.get_parent().take_damage(damage*2, direction, push_back_force*1.5)
	pass # replace with function body

#
func _on_thrust_area_enter( area ):
	if area.is_in_group("enermy_hurtbox"):
		direction = flip.get_scale().x
		area.get_parent().take_damage(damage, direction,push_back_force*1.75)
	pass # replace with function body
	
	
##call by player to move hitbox to active layer = 2
#func attack(atk_type):
#
#	if atk_type == "slash1":
#		slash1.set_collision_mask(2)
#	elif atk_type == "slash2":
#		slash2.set_collision_mask(2)
#	elif atk_type == "thrust":
#		thrust.set_collision_mask(2)
#	pass
##return all hitbox back to rest layer = 20
#func stop_atk():
#	slash1.set_collision_mask(20)
#	slash2.set_collision_mask(20)
#	thrust.set_collision_mask(20)
#	slash1.set_collision_mask(20)
#	slash2.set_collision_mask(20)
#	thrust.set_collision_mask(20)
#	
#	pass
#
