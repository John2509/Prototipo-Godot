extends KinematicBody2D

var direcao = Vector2()
var colidiu = false
const velocidade = 600

func _ready():
	set_fixed_process(true)
	set_rot(direcao.angle())

func _fixed_process(delta):
	if (not is_colliding() and not colidiu):
		move(direcao * delta * velocidade)
	else:
		queue_free()

func set_direcao(dir):
	direcao = dir
