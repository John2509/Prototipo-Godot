extends Node2D

var explodiu = false 

var new_animation = ""
var animation = ""

func _ready():
	set_fixed_process(true)
	new_animation = "idle"
	if animation != new_animation:
			get_node("PcCima/AnimationExplosion").play(new_animation)
			get_node("PcBaixo/AnimationExplosion").play(new_animation)
			animation = new_animation
	pass
	
func _on_Area2D_body_enter( body ):
	if body.is_in_group("bala"):
		if explodiu == false:
			new_animation = "boom"
			explodiu = not explodiu
				
		if animation != new_animation:
			get_node("PcCima/AnimationExplosion").play(new_animation)
			get_node("PcBaixo/AnimationExplosion").play(new_animation)
			animation = new_animation
	pass

	
func _fixed_process(delta):
	get_node("PcCima/Collision").set_trigger(not explodiu)
	get_node("PcBaixo/Collision").set_trigger(not explodiu)
	
