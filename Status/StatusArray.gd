
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
	pass

#update all status inside the array
func update(delta):
	for i in range(list.size()):
		list[i].update(delta)
		if list[i].duration <= 0:
			remove(list[i], i)
		pass
	pass

#remove the status from the array
#pos: its position inside the array
func remove(status, pos):
	status.rev_start_effect()
	list.remove(i)
	pass