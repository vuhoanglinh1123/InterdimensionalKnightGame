extends "res://Status/Status.gd"

var base_damage = 1

func _init(t, dur, lv).(t, dur, lv):
	type = Utils.STATUS.POISON

func combine(status):
	if status.type == Utils.STATUS.POISON:
		#erase previous start effect
		rev_start_effect()
		#upgrade level if combine with stronger poison
		if level < status.level:
			level = status.level

		if level == status.level:
			if duration < status.duration:
				duration = status.duration
		else:
			duration = (duration*level + status.duration*status.level)/(level+status.level)
		#reapply effect
		start_effect()
		return true
		pass
	#no match type
	return false
	pass