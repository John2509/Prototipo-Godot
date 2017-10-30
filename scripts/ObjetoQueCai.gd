extends Node2D

#var IS_FALLING = 0 #se esta caindo, pode matar

#func _input(event):
#	print("nao apertou")
#	#IS_FALLING = event.is_action_pressed("drop_all") #checar se alguem interagiu com um dos objetos
#	if (event.is_action_pressed("drop_all")):
#		print("apertou")
#		set_mode(2)

func _fixed_process(delta):
	if (ativar()):
		for filho in get_children():
			filho.set_sleeping(false)

func ativar():
	return Input.is_action_pressed("drop_all")

func _ready():
	for filho in get_children():
		print(filho.get_name())
		filho.set_sleeping(true)
	set_fixed_process(true)
	pass
