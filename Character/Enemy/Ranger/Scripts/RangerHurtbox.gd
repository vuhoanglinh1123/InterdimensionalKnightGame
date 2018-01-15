extends Area2D

onready var flip = get_parent().get_node("flip")
onready var parent = get_parent()
onready var target = Utils.get_main_node().get_node("player")

var damage_dir

func _ready():
	
	pass

func _on_hurtbox_area_enter( area ):
	if area.is_in_group("PLAYER"):
		damage_dir = sign(target.get_pos().x - parent.get_pos().x)
		target.take_damage(parent.contact_damage, damage_dir, parent.knockback_force)
	pass # replace with function body
