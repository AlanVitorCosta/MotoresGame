extends Area2D

func _ready():
	pass 

func _on_Area2D_body_entered(body):
	#print(body.name)
	body.queue_free()	
	pass # Replace with function body.
