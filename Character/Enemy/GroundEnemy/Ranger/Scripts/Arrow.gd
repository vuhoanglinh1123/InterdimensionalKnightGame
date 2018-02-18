extends KinematicBody2D

onready var flip = get_node("flip")
onready var anim = flip.get_node("sprite/anim")
onready var hitbox = flip.get_node("hitbox")
onready var parent = get_parent()

var direction
var projectile_range
var projectile_speed
var distance = 0
var velocity = Vector2()

func _ready():
	set_process(true)
#	set_pos(parent.get_global_pos())
	flip.set_scale(Vector2(direction, 1))
	anim.play("flying")
	pass

func _process(delta):
	if distance >= projectile_range:
		destroy()
	
	velocity = Vector2(projectile_speed * direction, 0) * delta
	distance = distance + projectile_speed * delta
	move(velocity)
	pass

func _on_hitbox_area_enter( area ):
	if area.is_in_group("PLAYER"):
#		var damage_dir = direction
#		target.take_damage(CONTACT_DMG, damage_dir, KNOCKBACK_FORCE)
		destroy()
	pass # replace with function body

func destroy():
	set_process(false)
	anim.play("destroy")
	yield(anim, "finished")
	queue_free()
	pass

