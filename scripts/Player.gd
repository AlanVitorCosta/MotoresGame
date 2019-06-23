extends KinematicBody2D

const SPEED = 100
const GRAVITY = 10
const JUMP_POWER = -450
const FLOOR = Vector2(0, -1)

onready var sprite = get_node("Sprite")
onready var collider2d = get_node("CollisionShape2D")

var play_particles = 0
var tocar_musicFx = 0
var tocar_deathFx = 0
var tocar_moveFx = 0
var can_change_scene = false
var anim setget set_anim
var velocity = Vector2()
var on_ground = false
var can_animate_jump = false
var recycling_points = 0

func _ready():
	anim = "Idle"
	recycling_points = 0
	$musicFx.play()
	pass 

func _physics_process(delta):
	collider2d.scale = Vector2 (1, 1)
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = 6*SPEED
		if anim == "Crouch":
			velocity.x = 4*SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x = 2*SPEED
		if anim == "Crouch":
			velocity.x = SPEED
	else:
		velocity.x = 4*SPEED
		if anim == "Crouch":
			velocity.x = 2*SPEED
	
	if Input.is_action_pressed("ui_up") && on_ground && !Input.is_action_pressed("ui_down") && anim != "Falling":
		velocity.y = JUMP_POWER
		
	if Input.is_action_pressed("ui_down") && anim != "Falling":
		anim = "Crouch"
		collider2d.scale = Vector2 (0.75, 0.75)
	elif !on_ground && Input.is_action_pressed("ui_up") && can_animate_jump:
		anim = "Jump"
		$jumpFx.play()
		can_animate_jump = false
	elif(on_ground && anim != "Falling"):
		anim = "Idle"
	
	if anim == "Falling":
		collider2d.scale = Vector2 (1, 0.65)
		velocity = Vector2(0, 100)
		can_animate_jump = false
		if tocar_deathFx == 0:
			$deathFx.play()
			tocar_deathFx = 1
	
	if can_change_scene == true:
		get_tree().change_scene("res://scenes/GameOver.tscn")
	
	if Input.is_key_pressed(KEY_Z):
		$Camera2D.zoom = Vector2(4,4)
	else:
		$Camera2D.zoom = Vector2(1,1)	
	
	sprite.play(anim)
	
	velocity.y += GRAVITY
	
	if tocar_moveFx == 1 && velocity.y < -230:
			$moveFx.stop()
			tocar_moveFx = 0
	
	if is_on_floor():
		on_ground = true
		can_animate_jump = true
		
		if play_particles == 0:
			$Particles2D.emitting = true
			play_particles = 1
		
		if tocar_moveFx == 0:
			$moveFx.play()
			tocar_moveFx = 1
	else:
		on_ground = false
		
		if play_particles == 1:
			$Particles2D.emitting = false
			play_particles = 0
	
	velocity = move_and_slide(velocity, FLOOR)
	pass
	
func set_anim(new_anim):
	anim = new_anim

func _on_Sprite_animation_finished():
	if anim == "Falling" && tocar_deathFx == 2:
		can_change_scene = true

func _on_moveFx_finished():
	tocar_moveFx = 0

func _on_deathFx_finished():
	tocar_deathFx = 2
