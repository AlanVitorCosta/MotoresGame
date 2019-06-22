extends KinematicBody2D

const SPEED = -100
const GRAVITY = 100
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

func _ready():
	pass 

func _physics_process(delta):
	velocity.x = 4*SPEED
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR)
	pass

func _on_Area2D_body_entered(body):
	if(body.get_name() == "Player"):
		body.anim = "Falling"
		queue_free()