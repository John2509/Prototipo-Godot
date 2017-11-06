extends KinematicBody2D

var direcao = Vector2()
var colidiu = false
var time
const velocidade = 600
const TIME_MAX = 0.4

var new_animation = ""
var animation = ""

func _ready():
	set_fixed_process(true)
	set_rot(direcao.angle())
	time = 0.0

func _fixed_process(delta):
	new_animation = "fading" 
	if (not is_colliding() and not colidiu and time < TIME_MAX) :
		move(direcao * delta * velocidade)
		time += delta
	else:
		queue_free()
		
	if animation != new_animation:
		get_node("AnimationBall").play(new_animation)
		animation = new_animation

func set_direcao(dir):
	direcao = dir
