extends Control

#always let it be the children of the node u want to display debugger


#onready
onready var target = get_parent()
onready var state_label = get_node("state_label")
onready var linear_velocity_label = get_node("linear_velocity_label")
onready var atk_state_label = get_node("atk_state_label")
onready var health_label = get_node("health_label")
onready var element_label = get_node("element_label")
onready var anim_label = get_node("anim_label")

var state_machine

#var
var state_label_begin = "State: "
var atk_state_label_begin = "Atk State:"
var health_label_begin = "Health: "
var element_label_begin = "Element: "
var anim_label_begin = "Anim: "
var velocity_label_begin = "Velocity: "

func _ready():
	if target.DEBUG_MODE:
		if target.state_machine != null:
			state_machine = target.state_machine
		set_process(true)
		set_hidden(false)
	else:
		set_hidden(true)
	pass

func _process(delta):
	
	state_label.set_text(state_label_begin + str(state_machine.get_current_state()))
	
	linear_velocity_label.set_text(velocity_label_begin + str(target.get_linear_velocity()) )
	
	health_label.set_text(health_label_begin + str(target.current_health) )
	
	anim_label.set_text(anim_label_begin + str(target.anim.get_current_animation()))
	pass
