extends "res://Status/Status.gd"

var base_damage = 1

func _init():
	type = Utils.STATUS.POISON

func combine(status):
	if status.type == Utils.STATUS.POISON:
		#upgrade level if combine with stronger poison
		if level < status.level:
			level = status.level

		if level == status.level:
			if duration < status.duration:
				duration = status.duration
		else:
			duration = (duration*level + status.duration*status.level)/(level+status.level)
		return true
	#no match type
	return false
	pass

#call when timer == tick_time
func tickEffect():
	target.cur_health -= base_damage*level
	pass