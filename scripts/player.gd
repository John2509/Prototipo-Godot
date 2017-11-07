extends KinematicBody2D

# This is a simple collision demo showing how
# the kinematic controller works.
# move() will allow to move the node, and will
# always move it to a non-colliding spot,
# as long as it starts from a non-colliding spot too.

# Member variables
const GRAVITY = 1500.0 # Pixels/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 1800
const WALK_MIN_SPEED = 30
const WALK_MAX_SPEED = 300
const STOP_FORCE = 3000
const JUMP_SPEED = 600
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 5.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL = 5.0 # One pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false

var esta_atirando = false

var dead = false

var walk_left_text = "move_left_p"
var walk_right_text = "move_right_p"
var jump_text = "jump_p"
var shoot_text= "shoot_p"
var look_up_text = "look_up_p"
var look_down_text = "look_down_p"

var new_animation = ""
var animation = ""

var direcao = Vector2(1,0)

func _fixed_process(delta):
	if (not get_node("AnimationPlayer").is_playing() and dead):
		queue_free()
	mover(delta)
	atirar()

func atirar():
	
	var atirar = Input.is_action_pressed(shoot_text)
	if (atirar and not esta_atirando and not dead):
		var verificar = false
		var aux = direcao.x
		if (Input.is_action_pressed(look_up_text)):
			direcao.y += -1
			verificar = true
		if (Input.is_action_pressed(look_down_text)):
			direcao.y += 1
			verificar = true
		if (verificar and direcao.y != 0 and not Input.is_action_pressed(walk_left_text) and not Input.is_action_pressed(walk_right_text)):
			direcao.x = 0
			
		var shot = preload("res://scenes/bala.tscn").instance()
		shot.set_direcao(direcao)
		shot.set_pos(get_global_pos()+Vector2(direcao.x*30,direcao.y*45))
		get_node("../").add_child(shot)
		direcao.y = 0
		direcao.x = aux	
		
	esta_atirando = atirar
			
func mover(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed(walk_left_text)
	var walk_right = Input.is_action_pressed(walk_right_text)
	var jump = Input.is_action_pressed(jump_text)
	
	var stop = true
	
	if (walk_right && walk_left):
		stop = true
	elif (walk_left):
		if (velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED):
			force.x -= WALK_FORCE
			stop = false
		elif(velocity.x > WALK_MIN_SPEED):
			velocity.x = 0
		direcao.x = -1
	elif (walk_right):
		if (velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED):
			force.x += WALK_FORCE
			stop = false
		elif(velocity.x < -WALK_MIN_SPEED):
			velocity.x = 0
		direcao.x = 1
	
	if (stop):
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE*delta
		if (vlen < 0):
			vlen = 0
		
		velocity.x = vlen*vsign
	
	# Integrate forces to velocity
	velocity += force*delta
	
	# Integrate velocity into motion and move
	var motion = velocity*delta
	
	# Move and consume motion
	motion = move(motion)
	
	var floor_velocity = Vector2()
	
	if (is_colliding()):
		# You can check which tile was collision against with this
		# print(get_collider_metadata())
		
		# Ran against something, is it the floor? Get normal
		var n = get_collision_normal()
		
		if (rad2deg(acos(n.dot(Vector2(0, -1)))) < FLOOR_ANGLE_TOLERANCE):
			# If angle to the "up" vectors is < angle tolerance
			# Dot é um produto escalar de vetores que da um angulo
			# char is on floor
			on_air_time = 0
			floor_velocity = get_collider_velocity()
		
		if (dead or (on_air_time == 0 and force.x == 0 and get_travel().length() < SLIDE_STOP_MIN_TRAVEL and abs(velocity.x) < SLIDE_STOP_VELOCITY and get_collider_velocity() == Vector2())):
			# Since this formula will always slide the character around, 
			# a special case must be considered to to stop it from moving 
			# if standing on an inclined floor. Conditions are:
			# 1) Standing on floor (on_air_time == 0)
			# 2) Did not move more than one pixel (get_travel().length() < SLIDE_STOP_MIN_TRAVEL)
			# 3) Not moving horizontally (abs(velocity.x) < SLIDE_STOP_VELOCITY)
			# 4) Collider is not moving
			
			revert_motion()
			velocity.y = 0.0
		else:
			# For every other case of motion, our motion was interrupted.
			# Try to complete the motion by "sliding" by the normal
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			# Then move again
			move(motion)
	
	if (floor_velocity != Vector2()):
		# If floor moves, move with floor
		move(floor_velocity*delta)
	
	if (jumping and velocity.y > 0):
		# If falling, no longer jumping
		jumping = false
	
	if (not dead and (on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping)):
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = jump
	
	var tfloor = get_node("rayFloor").is_colliding()
	
	var walking = false
	
	if walk_right and not dead:
		get_node("Sprite").set_flip_h(false)
		walking = true

	if walk_left and not dead:
		get_node("Sprite").set_flip_h(true)
		walking = true
	
	var tfloor = get_node("rayFloor").is_colliding()
	
	if walking:
		if tfloor && !esta_atirando:
			new_animation = "walking"
		elif !tfloor && !esta_atirando:
			new_animation = "jumping"
		elif tfloor && esta_atirando:
			new_animation = "shooting"
		elif !tfloor && esta_atirando:
			new_animation = "jumpingshoot"
	else:
		if tfloor && !esta_atirando:
			new_animation = "idle"
		elif !tfloor && !esta_atirando:
			new_animation = "jumping"
		elif tfloor && esta_atirando:
			new_animation = "shooting"
		elif !tfloor && esta_atirando:
			new_animation = "jumpingshoot"
	
	if (dead):
		new_animation = "dying"
	
	if animation != new_animation:
		get_node("AnimationPlayer").play(new_animation)
		animation = new_animation
	

func _ready():
	add_to_group("player") 
	set_fixed_process(true)
	set_process_input(true)
	var numero
	if (get_name() == "player1" or get_name() == "player"):
		numero = "1"
	else:
		numero = "2"
	walk_left_text += numero
	walk_right_text += numero
	jump_text += numero
	shoot_text += numero
	look_up_text += numero
	look_down_text += numero
	get_child(0).set_texture(load("res://sprites/paiva0"+numero+".png"))


func kill():
	dead = true
	new_animation = "dying"
	get_node("AnimationPlayer").play(new_animation)
	get_parent().player_morreu(get_name())
