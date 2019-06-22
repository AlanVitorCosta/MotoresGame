extends KinematicBody2D

const GRAVITY = 9
const FLOOR = Vector2(0, -1)

onready var timer = get_node("Timer")

var velocity = Vector2()

func _ready():
	$camelFx.play()
	
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.set_wait_time(7)
	timer.start()
	pass 

func _physics_process(delta):
	velocity.y += GRAVITY
	
	move_and_slide(velocity, FLOOR, true)
	pass

func _on_Area2D_body_entered(body):
	if(body.get_name() == "Player"):
		body.anim = "Falling"
		queue_free()

func _on_timer_timeout():
		print("destruiu")
		queue_free()