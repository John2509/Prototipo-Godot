extends Node2D


var aberta = false


func _ready():
	set_fixed_process(true)
	pass

func _on_Area2D_body_enter( body ):
	if body.is_in_group("bala"):
		aberta = not aberta
		print("mudou")
		#mudar sprite
	pass # replace with function body

func _fixed_process(delta):
	get_node("porta_baixo/Collision").set_trigger(not aberta)
	get_node("porta_cima/Collision").set_trigger(not aberta)