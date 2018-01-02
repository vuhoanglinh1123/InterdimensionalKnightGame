extends Node

var body
var stack

var update_func
var prev_state = ""

func _init(body):
	self.body = body
	init_variable()
	pass

func init_variable():
	stack = Array()
	pass

func update():
	var cur_state = get_current_state()
	if cur_state != null:
		if cur_state != prev_state:
			update_func = funcref(body, cur_state)
			prev_state = cur_state
		update_func.call_func()
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
