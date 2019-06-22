extends KinematicBody2D

const SPEED = 100
const GRAVITY = 10
const JUMP_POWER = -500
const FLOOR = Vector2(0, -1)

onready var sprite = get_node("Sprite")
onready var collider2d = get_node("CollisionShape2D")

var anim setget set_anim
var velocity = Vector2()
var on_ground = false
var can_animate_jump = false
var recycling_points = 0

func _ready():
	anim = "Idle"
	recycling_points = 0
	pass 

func _physics_process(delta):
	collider2d.scale = Vector2 (1, 1)
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = 8*SPEED
		if anim == "Crouch":
			velocity.x = 6*SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x = 3*SPEED
		if anim == "Crouch":
			velocity.x = SPEED
	else:
		velocity.x = 5*SPEED
		if anim == "Crouch":
			velocity.x = 3*SPEED
			
	if Input.is_action_pressed("ui_up") && on_ground && !Input.is_action_pressed("ui_down") && anim != "Falling":
		velocity.y = JUMP_POWER
		
	if Input.is_action_pressed("ui_down") && anim != "Falling":
		anim = "Crouch"
		collider2d.scale = Vector2 (0.8, 0.8)
	elif !on_ground && Input.is_action_pressed("ui_up") && can_animate_jump:
		anim = "Jump"
		can_animate_jump = false
	elif(on_ground && anim != "Falling"):
		anim = "Idle"
		
	if anim == "Falling":
		collider2d.scale = Vector2 (1, 0.65)
		velocity = Vector2(0, 100)
		can_animate_jump = false
		
	if Input.is_key_pressed(KEY_Z):
		$Camera2D.zoom = Vector2(4,4)
	else:
		$Camera2D.zoom = Vector2(1,1)	
	
	sprite.play(anim)
	
	velocity.y += GRAVITY
	
	if is_on_floor():
		on_ground = true
		can_animate_jump = true
	else:
		on_ground = false
	
	velocity = move_and_slide(velocity, FLOOR)
	pass
	
func set_anim(new_anim):
	anim = new_anim