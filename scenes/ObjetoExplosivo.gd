extends Node
var time
var ativar = false
var mortal = false

func _fixed_process(delta):
	if (ativar):
		for filho in get_children():
			get_node("AnimationPlayer").play("telaAzul")
			get_node("AnimationPlayer").queue("BOOM")
	if(get_node("AnimationPlayer").get_current_animation() == "BOOM"):
		mortal = true
		for filho in get_children():
			if (filho.get_type() == "RigidBody2D"):
				ativar = false
				mortal = false

func _ready():
	add_to_group("objeto")
	time = 0.0
	for filho in get_children():
		if (filho.get_type() == "RigidBody2D"):
			filho.set_sleeping(true)
			filho.set_mode(0)
			filho.set_gravity_scale(0)
	set_fixed_process(true)
	pass

func _on_Area2D_body_enter( body ):
	if	body.is_in_group("bala") and not ativar:
		ativar = true
	if(mortal):
		if body.is_in_group("player"):
			body.kill()
	