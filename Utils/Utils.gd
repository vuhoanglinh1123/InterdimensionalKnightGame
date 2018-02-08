extends Node

##PRELOAD
var StatusPoison = preload("res://Environment/ElementalStatus/StatusPoison.gd")

#enum
enum STATUS{
	POISON = 1
}

var elapsed_time = 0  # Time from the start of the game
var fixed_delta = 0   # Physics engine ticks

func _ready():
	set_process(true)
	set_fixed_process(true)
	pass

func _process(delta):
	elapsed_time += delta
	pass

func _fixed_process(delta):
	fixed_delta = delta
	pass

##COMMON FUNCTIONS
func get_main_node():
	var root_node = get_tree().get_root()
	
	return root_node.get_child(root_node.get_child_count() - 1)
	pass

#create a status
func creat_status(type, target, duration, level):
	if type == STATUS.POISON:
		return StatusPoison.new(target, duration, level)
	pass