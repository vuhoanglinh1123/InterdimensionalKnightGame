var body
var body_position
var target_position
var traces
var trace_range

func _init(body):
	self.body = body
	init_variable()
	pass

func init_variable():
	body_position   = body.get_pos()
	target_position = body.target.get_pos()
	trace_range = round(body.PURSUIT_RANGE/body.TRACE_AMOUNT)
	traces = Array()
	pass

func pursuit():
	body_position   = body.get_pos()
	target_position = body.target.get_pos()
	set_trace()
	
	if body.ground_check():
		move_to_next_trace()
		if body.get_linear_velocity().x != 0:
			body.direction = sign(body.get_linear_velocity().x)
	pass

func set_trace():
	if traces.empty():
		traces.append(body_position)
	
	# Make a trace every "trace_range" distance
	if traces.back().distance_to(target_position) >= trace_range:
		traces.append(target_position)
	
	# To avoid making too many traces
	if traces.size() > round(body.PURSUIT_RANGE/trace_range):
		traces.pop_front()
	
	pass

func move_to_next_trace():
	body.move(traces.front(), body.PURSUIT_VELOCITY)
		
	# Detect when to jump
	if body_position.y > traces.front().y + 50:
		if body_position.y > target_position.y + 50 and body.target.ground_check() and body.JUMPABLE:
			jump()
		else:
			# won't jump if BODY and TARGET is on the same ground
			traces.pop_front()
	elif body_position.y <= traces.front().y and abs(body_position.x - traces.front().x) <= 100:
		traces.pop_front()
	# Remove the trace when BODY gets close to it
	elif body_position.distance_to(traces.front()) <= trace_range:
		traces.pop_front()
	pass

func jump():
	if body.ground_check():
		body.set_axis_velocity(Vector2(0, -body.JUMP_FORCE))
	pass

func exit():
	traces.clear()
	pass