extends Button

func _ready():
	connect("pressed", self, "_on_Button_pressed")
	pass 

func _on_Button_pressed():
	get_tree().change_scene("res://scenes/World.tscn")
