extends KinematicBody2D

const RECICLAVEIS = {
	'nothing': -1,
	'garrafa': 0,
	'lata': 1,
	'plastico': 2,
	'pneu': 3
}

const GRAVITY = 300

var collider_y_height = rand_range(0.5,1.8)
var velocity = Vector2()
var points 
var itemID = RECICLAVEIS.nothing
var spr_texture = preload("res://icon.png")
var garrafa_texture = preload("res://sprites/Coletaveis/garrafa.png")
var lata_texture = preload("res://sprites/Coletaveis/lixo1.png")
var plastico_texture = preload("res://sprites/Coletaveis/lixo2.png")
var pneu_texture = preload("res://sprites/Coletaveis/pneu.png")
var falling = true

func _ready():
	$Sprite.texture = spr_texture
	if(itemID != RECICLAVEIS.nothing):
		get_sprite_by_itemID(itemID)
	
	$Altura1.scale = Vector2 (1, collider_y_height)
	pass

func _physics_process(delta):
	velocity.y += GRAVITY
	move_and_collide(velocity * delta)
	pass

func get_sprite_by_itemID(itemID):
	if itemID == RECICLAVEIS.garrafa:
		$Sprite.texture = garrafa_texture
		$Sprite.scale = Vector2(1.35, 1.35)
		$Position/CollisionShape2D.scale = Vector2(1.2, 1.2)
	if itemID == RECICLAVEIS.lata:
		$Sprite.texture = lata_texture
		$Sprite.scale = Vector2(5, 5)
		$Position/CollisionShape2D.scale = Vector2(4.5, 4.5)
	if itemID == RECICLAVEIS.plastico:
		$Sprite.texture = plastico_texture
		$Sprite.scale = Vector2(3, 3)
		$Position/CollisionShape2D.scale = Vector2(2.7, 2.7)
	if itemID == RECICLAVEIS.pneu:
		$Sprite.texture = pneu_texture
		$Sprite.scale = Vector2(0.9, 0.9)
		$Position/CollisionShape2D.scale = Vector2(1, 1)
	else:
		return 
	pass

func get_points_by_itemID(itemID):
	if itemID == RECICLAVEIS.garrafa:
		print("lixo spawn garrafa")
		return 5
	if itemID == RECICLAVEIS.lata:
		print("lixo spawn lata")
		return 4
	if itemID == RECICLAVEIS.plastico:
		print("lixo spawn plastico")
		return 10
	if itemID == RECICLAVEIS.pneu:
		print("lixo spawn pneu")
		return 12
	else:
		return 0
	pass

func _on_colletableFx_finished():
	if $Particles2D.emitting == false:
		queue_free()

func _on_Position_body_entered(body):
	if(body.get_name() == "Player"):
		body.recycling_points = body.recycling_points + get_points_by_itemID(itemID)
		$Sprite.visible = false
		$Particles2D.emitting = true
		$colletableFx.play()
	pass 
