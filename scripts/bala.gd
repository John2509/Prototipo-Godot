extends KinematicBody2D

var direcao = Vector2()
var colidiu = false
var time
const velocidade = 600
const TIME_MAX = 0.3

func _ready():
	set_fixed_process(true)
	set_rot(direcao.angle())
	time = 0.0

func _fixed_process(delta):
	if (not is_colliding() and not colidiu and time < TIME_MAX) :
		move(direcao * delta * velocidade)
		time += delta
	else:
		queue_free()

func set_direcao(dir):
	direcao = dir
