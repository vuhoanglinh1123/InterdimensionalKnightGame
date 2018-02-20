##BASE CLASS FOR EACH ATTACK STATE

#current update func of the atk state, continuously run 
var update_func
##basic state
#user
var USER
#the base weapon hold this state
var WEAPON
#hitbox of this atk
var HITBOX
#animation player of this atk
var ANIM_PLAYER
#animation name of this atk
var ANIM_NAME

#contructor
func _init(weapon):
	WEAPON = weapon
	USER = WEAPON.user
	switch_windup_func()
	pass
#update
func update():
	update_func.call_func()
	pass
##switch func run 1 time at init
#windup func
func switch_windup_func():	
	update_func = funcref(self, "windup_func")
	pass
#updatee
func windup_func():
	
	pass
#attack func
func switch_attack_func():
	update_func = funcref(self, "attack_func")
	if HITBOX != null:
		HITBOX.set_enable_monitoring(true)
	pass
	
func attack_func():
	
	pass
#callback func
func switch_callback_func():
	update_func = funcref(self, "callback_func")
	#make sure set_enable_monitoring(false) work during body_enter()
	if HITBOX != null:
		HITBOX.call_deferred("set_enable_monitoring", false)
	pass
	
func callback_func():
	
	pass
#end func
func switch_end_func():
	
	pass
#end dont have continously run function

