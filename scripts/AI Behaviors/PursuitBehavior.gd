extends "res://scripts/AI Behaviors/PatrolBehavior.gd"

onready var player_dt = get_node("flip/player_detector")
onready var PLAYER = utils.get_main_node().get_node("player")

export var range_offset   = 200
export var chase_velocity = 300
export var turn_rate      = 5

const PLAYER_SIZE  = 128

var player_dt_range

func _ready():
	player_dt.add_exception(self)
	player_dt_range = player_dt.get_cast_to().x + range_offset
	pass

# Check whether PLAYER is out of SELF range
func is_player_out_of_range():
	var distance_to_player = self.get_pos().distance_to(PLAYER.get_pos())
	if distance_to_player > player_dt_range + PLAYER_SIZE/2:
		return true
	else:
		return false
	pass

#func _draw():
#	draw_circle(Vector2(0,0), player_dt_range, Color(1, 0, 0, 0.3))
#	pass

# Rush to the PLAYER in CHASE state
func pursuitBehavior():
	if PLAYER.get_pos().y <= self.get_pos().y:
		direction = 1 * sign(PLAYER.get_pos().x - self.get_pos().x) 
	
	speed.x = lerp(speed.x, direction * max_velocity, accerleration*0.01) #acc * 0.01, turn into percent
	set_linear_velocity(Vector2( speed.x, get_linear_velocity().y ))
	pass