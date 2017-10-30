extends KinematicBody2D

var direcao = Vector2()
const velocidade = 100

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if (not is_colliding()):
		move(direcao * delta * velocidade)
	else:
		queue_free()

func set_direcao(dir):
	direcao = dir
