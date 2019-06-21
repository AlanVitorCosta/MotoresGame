extends KinematicBody2D

const SPEED = -100
const GRAVITY = 100
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

func _ready():
	pass 

func _physics_process(delta):
	velocity.x = 2*SPEED
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR)
	pass

