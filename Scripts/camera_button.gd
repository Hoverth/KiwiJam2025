extends Node2D

signal camera_toggled

var camera_up = false
@onready var camera = $"../Camera"
@onready var eject = $"../EjectSeat"
func _on_button_mouse_entered() -> void:
	if not visible:
		return
	if not camera_up:
		camera.visible = true
		camera_up = true
		eject.visible = false
		$"../Clipboard".visible = false
		camera_toggled.emit()
	else:
		camera.visible = false
		camera_up = false
		eject.visible = true
		$"../Clipboard".visible = true
		camera_toggled.emit()

func clipboard_shown() -> void:
	visible = false

func clipboard_hidden() -> void:
	visible = true
