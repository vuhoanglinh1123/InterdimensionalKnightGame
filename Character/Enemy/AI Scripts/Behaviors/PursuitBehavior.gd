extends Node2D

const PLAYER_SIZE  = 128

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
	trace_range = 200
	traces = Array()
	pass

# Check whether PLAYER is out of SELF range
func is_player_out_of_range():
	var distance_to_player = body.get_pos().distance_to(body.target.get_pos())
	if distance_to_player > body.PURSUIT_RANGE + PLAYER_SIZE/2:
		return true
	else:
		return false
	pass

# Rush to the PLAYER in PURSUIT state
func pursuit():
	body.play_loop_anim("wander")
	
	body_position   = body.get_pos()
	target_position = body.target.get_pos()
	set_trace()
	move_to_next_trace()
	if body.get_linear_velocity().x != 0:
		body.direction = sign(body.get_linear_velocity().x)
	pass

func set_trace():
	if traces.empty():
		traces.append(body_position)
	
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
		if body_position.y > target_position.y + 50 and body.target.ground_check():
			jump()
		else:
			# won't jump if BODY and TARGET is on the same ground
			traces.pop_front()
#	elif body_position.y <= traces.front().y:
#		# TODO
	# Remove the trace when BODY gets close to it
	elif body_position.distance_to(traces.front()) <= trace_range:
		traces.pop_front()
	pass

func jump():
	if body.ground_check():
		body.set_axis_velocity(Vector2(0, -body.JUMP_FORCE))
		body.anim.play("jump")
	pass

func exit():
	traces.clear()
	pass