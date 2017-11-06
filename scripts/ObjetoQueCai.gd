extends Node2D

const TIME_MAX = 7.5
var ativar = false #se esta caindo, pode matar
var time
var matar = true

var new_animation = ""
var animation = ""


func _fixed_process(delta):
	#print ("ok")
	if (ativar):
		for filho in get_children():
			if (filho.get_type() == "RigidBody2D"):
				filho.set_sleeping(false)
				filho.set_gravity_scale(6)
			time += delta 
		if time > TIME_MAX:
			for filho in get_children():
				if (filho.get_type() == "RigidBody2D"):
					ativar = false
					filho.queue_free()
		#print ("nao ok")
	if animation != new_animation:
		get_node("AnimationObject").play(new_animation)
		animation = new_animation
		

func _ready():
	add_to_group("objeto")
	time = 0.0
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


func _on_Area2D_body_enter( body ):
	if body.is_in_group("bala"):
		ativar = true
	elif (ativar and body.is_in_group("player") and matar):
		body.kill() 
	elif (ativar and body.is_in_group("chao")):
		matar = false
	pass
 # replace with function body
