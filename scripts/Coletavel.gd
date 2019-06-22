extends Area2D

func _ready():
	pass

func _on_Coletavel_body_entered(body):
	if(body.get_name() == "Player"):
		body.anim = "Falling"
		queue_free()
	pass
