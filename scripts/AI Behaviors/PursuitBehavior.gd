extends Node

export var range_offset   = 200
export var chase_velocity = 300
export var jump_force     = 1200

const PLAYER_SIZE  = 128

var body
var player_dt_range

func _init(body):
	self.body = body
	first_run()
	pass

func first_run():
	player_dt_range = body.player_dt.get_cast_to().x + range_offset
	pass

# Check whether PLAYER is out of SELF range
func is_player_out_of_range():
	var distance_to_player = body.get_pos().distance_to(body.target.get_pos())
	if distance_to_player > player_dt_range + PLAYER_SIZE/2:
		return true
	else:
		return false
	pass

#func _draw():
#	draw_circle(Vector2(0,0), player_dt_range, Color(1, 0, 0, 0.3))
#	pass

# Rush to the PLAYER in CHASE state
func pursuit():
	if body.get_pos().y >= body.target.get_pos().y:
		body.direction = sign(body.target.get_pos().x - body.get_pos().x)

	body.speed.x   = lerp(body.speed.x, body.direction * chase_velocity, body.accerleration*0.01) #acc * 0.01, turn into percent
	body.set_linear_velocity(Vector2(body.speed.x, body.get_linear_velocity().y ))
	pass