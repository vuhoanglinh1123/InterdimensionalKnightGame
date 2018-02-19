extends Area2D

export var level = 1
export var duration = 3
var areas

func _ready():
	set_process(true)
	pass

func _process(delta):
	areas = get_overlapping_areas()
	for area in areas:
		if area.is_in_group("HURTBOX"):
			area.get_parent().apply_status(Utils.STATUS.POISON, duration, level)
	pass
