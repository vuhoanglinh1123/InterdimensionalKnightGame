extends Node

var body
var stack

func _init(body):
	self.body = body
	init_variable()
	pass

func init_variable():
	stack = Array()
	pass

func update():
	if get_current_state() != null:
		var function = funcref(body, get_current_state())
		function.call_func()
	pass

func pop_state():
	stack.pop_back()
	pass

func push_state(state):
	if get_current_state() != state:
		stack.push_back(state)
	pass

func get_current_state():
	if not stack.empty():
		return stack.back()
	else:
		return null
	pass
