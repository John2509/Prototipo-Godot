extends Node2D


var aberta = false

var new_animation = ""
var animation = ""


func _ready():
	set_fixed_process(true)
	new_animation = "idle"
	pass

func _on_Area2D_body_enter( body ):
	if body.is_in_group("bala"):
		if aberta == false:
			new_animation = "opening"
		else:
			new_animation = "closing"
		aberta = not aberta
		print("mudou")
		#mudar sprite
		
		if animation != new_animation:
			get_node("porta_baixo/AnimationDoor").play(new_animation)
			get_node("porta_cima/AnimationDoor").play(new_animation)
			animation = new_animation
		
	pass # replace with function body

func _fixed_process(delta):
	get_node("porta_baixo/Collision").set_trigger(not aberta)
	get_node("porta_cima/Collision").set_trigger(not aberta)