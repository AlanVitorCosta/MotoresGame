extends Area2D

const RECICLAVEIS = {
	'nothing': -1,
	'garrafa': 0,
	'lata': 1,
	'plastico': 2
}

var points 
var itemID = RECICLAVEIS.nothing
var spr_texture = preload("res://icon.png")
var garrafa_texture = preload("res://icon.png")
var lata_texture = preload("res://icon.png")
var plastico_texture = preload("res://icon.png")

func _ready():
	$Sprite.texture = spr_texture
	if(itemID != RECICLAVEIS.nothing):
		get_sprite_by_itemID(itemID)
	pass

func _on_Coletavel_body_entered(body):
	if(body.get_name() == "Player"):
		body.recycling_points = body.recycling_points + get_points_by_itemID(itemID)
		print(body.recycling_points)
		queue_free()
	pass

func get_sprite_by_itemID(itemID):
	if itemID == RECICLAVEIS.garrafa:
		$Sprite.texture = garrafa_texture
	if itemID == RECICLAVEIS.lata:
		$Sprite.texture = lata_texture
	if itemID == RECICLAVEIS.plastico:
		$Sprite.texture = plastico_texture
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