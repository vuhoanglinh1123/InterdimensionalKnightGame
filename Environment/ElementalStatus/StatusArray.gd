
var list = Array()

#add a status in to the array
#check if we can combine the new status into any existing status
func add(status):
	var done = false
	for i in range(list.size()):
		done = list[i].combine(status)
		if done:
			return
	#cannot combine into anything
	list.append(status)
	status.start_effect.call_func()
	pass

#update all status inside the array
func update(delta):
	var iter = list.size() - 1
	while(iter >= 0):
		if list[iter].duration <= 0:
			remove(list[iter], iter)
		list[iter].update(delta)
		iter -= 1
	pass

#remove the status from the array
#pos: its position inside the array
func remove(status, pos):
	status.rev_effect.call_func()
	list.remove(pos)
	pass