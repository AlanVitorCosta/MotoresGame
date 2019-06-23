extends KinematicBody2D

const RECICLAVEIS = {
	'nothing': -1,
	'garrafa': 0,
	'lata': 1,
	'plastico': 2
}
const GRAVITY = 10

var velocity = Vector2()
var points 
var itemID = RECICLAVEIS.nothing
var spr_texture = preload("res://icon.png")
var garrafa_texture = preload("res://icon.png")
var lata_texture = preload("res://icon.png")
var plastico_texture = preload("res://icon.png")
var falling = true
func _ready():
	$Sprite.texture = spr_texture
	if(itemID != RECICLAVEIS.nothing):
		get_sprite_by_itemID(itemID)
	pass
	
func _physics_process(delta):
	velocity.y += GRAVITY
	move_and_collide(velocity * delta)
	pass
	
func get_sprite_by_itemID(itemID):
	if itemID == RECICLAVEIS.garrafa:
		$Sprite.texture = garrafa_texture
		$Sprite.modulate = Color(255,0,0,1)
	if itemID == RECICLAVEIS.lata:
		$Sprite.texture = lata_texture
		$Sprite.modulate = Color(0,255,0,1)
	if itemID == RECICLAVEIS.plastico:
		$Sprite.texture = plastico_texture
		$Sprite.modulate = Color(0,0,255,1)
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
