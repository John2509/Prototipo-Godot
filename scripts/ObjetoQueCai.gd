extends KinematicBody2D
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const GRAVITY = 1500.0 # Pixels/second
const IS_FALLING = 0 #se esta caindo, pode matar
var velocity = 0
var speed = 0


func _fixed_process(delta):
	_mover(delta)
	pass
	
func _mover(delta):
	if(IS_FALLING):
		if(not is_colliding()):
				speed += GRAVITY * delta
				velocity = speed * delta
				move(Vector2 (0,velocity))
	else:
		IS_FALLING = Input.is_action_pressed("drop_all") #checar se alguem interagiu com um dos objetos
	pass
	
func _ready():
	set_fixed_process(true)
	pass
