extends Object
#var
#the object affected by this status
var target

var duration = 0
var timer = 0
var tick_time = 0
var level = 0

var type

#function
func constructor(t, dur, lv):
	target = t
	duration = dur
	level = lv
	pass

#combine with other status, return true if can combine, false if not
func combine(status):
	pass

#effect happen when the status is added into array or combined 
func startEffect():
	pass

#reverse the effect happen at the start
func revStartEffect():
	pass

#call when timer == tick_time
func tickEffect():
	pass

#update call by array each process 
func update(delta):
	duration -= delta
	timer += delta
	if timer >= tick_time:
		tickEffect()
		timer = 0
		
	pass