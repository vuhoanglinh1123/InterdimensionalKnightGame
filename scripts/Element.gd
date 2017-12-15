extends Node

var type = 0
var duration = 0
var level = 0
 
var has_stat_debug = false
#if false, the stat debug is already apply, else,not yet

func _ready():
	pass

func _init(t, d, l):
	type = t
	duration = d
	level = l
	pass
