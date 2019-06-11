extends KinematicBody2D

const SPEED = 100
const GRAVITY = 10
const JUMP_POWER = -350
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var on_ground = false

func _ready():
	pass 
	
func _physics_process(delta):
	
	if Input.is_action_pressed("ui_right"):
		$Sprite.set_flip_h(false)
		velocity.x = 6*SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$Sprite.set_flip_h(true)
	else:
		velocity.x = 10*SPEED
		
	if Input.is_action_pressed("ui_up") && on_ground:
			velocity.y = JUMP_POWER
	
	velocity.y += GRAVITY
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
	
	velocity = move_and_slide(velocity, FLOOR)
	pass
