extends KinematicBody2D

const GRAVITY = 25
const FLOOR = Vector2(0, -1)

var velocity = Vector2()

func _ready():
	pass 

func _physics_process(delta):
	velocity.y += GRAVITY
	
	move_and_slide(velocity, FLOOR, true)
	pass

func _on_Area2D_body_entered(body):
	if(body.get_name() == "Player"):
		body.anim = "Falling"
		queue_free()
