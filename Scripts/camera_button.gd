extends Node2D

var camera_up = false
@onready var camera = $"../Camera"
@onready var eject = $"../EjectSeat"
func _on_button_mouse_entered() -> void:
	if camera_up == false:
		camera.visible = true
		camera_up = true
		eject.visible = false
	else:
		camera.visible = false
		camera_up = false
		eject.visible = true
		
