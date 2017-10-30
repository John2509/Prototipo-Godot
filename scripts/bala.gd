extends KinematicBody2D

var direcao = Vector2(100,100)

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if (not is_colliding()):
		move(direcao * delta)
	else:
		queue_free()
	
