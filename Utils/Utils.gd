# game.gd

extends Node

var process_time = 0   # elapsed time since the start of the game
var fixed_process_time = 0

func _ready():
	set_process(true)
	set_fixed_process(true)
	pass

func _process(delta):
	process_time += delta
	pass

func _fixed_process(delta):
	fixed_process_time += delta
	pass

func get_main_node():
	var root_node = get_tree().get_root()
	
	return root_node.get_child(root_node.get_child_count() - 1)
	pass