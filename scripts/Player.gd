extends KinematicBody2D

const SPEED = 100
const GRAVITY = 10
const JUMP_POWER = -500
const FLOOR = Vector2(0, -1)

onready var sprite = get_node("Sprite")
onready var collider2d = get_node("CollisionShape2D")

var anim = "Idle"
var velocity = Vector2()
var on_ground = false

func _ready():
	pass 

func _physics_process(delta):
	
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
	
	if Input.is_action_pressed("ui_up") && on_ground && !Input.is_action_pressed("ui_down"):
		velocity.y = JUMP_POWER
		anim = "jump"
		#if !on_ground && !Input.is_action_pressed("ui_down"):
		#	anim = "Jump"
		
	if Input.is_action_pressed("ui_down"):
		anim = "Crouch"
	elif !on_ground && Input.is_action_pressed("ui_up"):
		anim = "Jump"
	else:
		anim = "Idle"
	
	
	
	if Input.is_key_pressed(KEY_Z):
		$Camera2D.zoom = Vector2(4,4)
	else:
		$Camera2D.zoom = Vector2(1,1)	
	
	sprite.play(anim)
	
	velocity.y += GRAVITY
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
	
	velocity = move_and_slide(velocity, FLOOR)
	pass
