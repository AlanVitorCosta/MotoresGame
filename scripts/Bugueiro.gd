extends KinematicBody2D

const SPEED = -100
const GRAVITY = 100
const FLOOR = Vector2(0, -1)

onready var timer = get_node("Timer")

var velocity = Vector2()
var first_collision = false

func _ready():
	$buggyFx.play()
	
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.set_wait_time(6)
	timer.start()
	pass 

func _physics_process(delta):
	velocity.x = 2*SPEED
	velocity.y += GRAVITY
	
	if first_collision == false:
		velocity = move_and_slide(velocity, FLOOR)
	else:
		var collision_info = move_and_collide(velocity * delta, true, true, true)
		if collision_info:
			var collision_normal = collision_info.normal
			var new_angle = rad2deg(collision_normal.angle_to_point(velocity * delta)) + 35 
			$AnimatedSprite.rotation_degrees = new_angle;
			#print(new_angle)
		velocity = move_and_slide(velocity, FLOOR)
	pass

func _on_Area2D_body_entered(body):
	if(body.get_name() == "Player"):
		body.anim = "Falling"
		queue_free()
	else:
		if typeof(body) == 17:
			first_collision = true

func _on_timer_timeout():
		print("destruiu")
		queue_free()