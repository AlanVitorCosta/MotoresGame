extends Control

onready var timer = get_node("Timer")

var tocar = true

func _ready():
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.set_wait_time(0.2)
	timer.start()
	pass

func _on_timer_timeout():
	if tocar == true:
		$gameoverFx.play()
		tocar = false
