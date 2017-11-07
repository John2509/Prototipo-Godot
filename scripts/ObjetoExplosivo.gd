extends Node
var time
var ativar = false
var mortal = false

func _fixed_process(delta):
	if(get_node("PcBaixo/AnimationExplosion").get_current_animation() == "boom" and not mortal):
		mortal = true
		var area1 = load("res://scenes/Area_explosao.tscn").instance()
		var area2 = load("res://scenes/Area_explosao.tscn").instance()
		get_node("PcCima").add_child(area1)
		get_node("PcBaixo").add_child(area2)
	if (get_node("PcBaixo/AnimationExplosion").get_current_animation() == "end"):
		print(get_node("PcBaixo/AnimationExplosion").get_current_animation())
		queue_free()
	pass

func _ready():
	add_to_group("objeto")
	time = 0.0
	for filho in get_children():
		if (filho.get_type() == "StaticBody2D"):
			filho.get_node("AnimationExplosion").play("idle")
	set_fixed_process(true)
	pass


func _on_Area2D_body_enter( body ):
	if	body.is_in_group("bala") and not ativar:
		ativar = true
		for filho in get_children():
			filho.get_node("AnimationExplosion").play("telaAzul")
			filho.get_node("AnimationExplosion").queue("boom")
			filho.get_node("AnimationExplosion").queue("end")

