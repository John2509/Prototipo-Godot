extends KinematicBody2D

var direcao = Vector2(1,0)
var colidiu = false
const velocidade = 1000

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
