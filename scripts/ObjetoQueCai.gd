extends Node2D

#var IS_FALLING = 0 #se esta caindo, pode matar

func _fixed_process(delta):
	#print ("ok")
	if (ativar()):
		for filho in get_children():
			if (filho.get_type() == "RigidBody2D"):
				filho.set_sleeping(false)
				filho.set_gravity_scale(6)
		#print ("nao ok")

func ativar():
	return Input.is_action_pressed("drop_all")

func _ready():
	#print("teste")
	for filho in get_children():
		if (filho.get_type() == "RigidBody2D"):
			filho.set_sleeping(true)
			#print(filho.get_name())
			#print(filho.is_sleeping())
			#print(filho.get_mode())
			filho.set_mode(0)
			filho.set_gravity_scale(0)
	set_fixed_process(true)
	pass
