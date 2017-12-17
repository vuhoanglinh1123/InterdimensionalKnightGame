extends Control

#always let it be the children of the node u want to display debugger


#onready
onready var target = get_parent()
onready var state_label = get_node("state_label")
onready var linear_velocity_label = get_node("linear_velocity_label")
onready var atk_state_label = get_node("atk_state_label")
onready var health_label = get_node("health_label")
onready var element_label = get_node("element_label")
#var
var state_label_begin = "State: "
var atk_state_label_begin = "Atk State:"
var health_label_begin = "Health: "
var element_label_begin = "Element: "

func _ready():
	set_process(true)
	pass

func flip():
	set_scale( Vector2( target.direction, 1 ) )
	var children = get_children()
	for child in children:
		child.set_scale( Vector2( target.direction, 1 ) )
	
func _process(delta):
	flip()
	state_label.set_text(state_label_begin + str(target.get_current_state()))
	
	linear_velocity_label.set_text( str(target.get_linear_velocity()) )
	
#	atk_state_label.set_text(atk_state_label_begin + target.atk_move)
	
	health_label.set_text(health_label_begin + str(target.cur_health) )
	
#	element_label.set_text(element_label_begin + target.element)
	pass
