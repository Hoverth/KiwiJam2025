extends Node2D

@onready var camera_list = [[$"Cam 1/State 1", $"Cam 1/State 2"],[$"Cam 2/State 1", $"Cam 2/State 2"],[$"Cam 3/State 1", $"Cam 3/State 2"]]
@onready var cameras = [$"Cam 1", $"Cam 2", $"Cam 3"]
@onready var audio = $AudioStreamPlayer2D
var cam1_broke = false
var cam2_broke = false
var cam3_broke = false

func _on_button_pressed() -> void:
	if cam1_broke == true:
		camera_list[0][1].visible = true
		camera_list[0][0].visible = false
		audio.play()
	else: 
		camera_list[0][1].visible = false
		camera_list[0][0].visible = true
		audio.stop()
	cameras[0].visible = true
	cameras[1].visible = false
	cameras[2].visible = false

func _on_button_2_pressed() -> void:
	if cam2_broke == true:
		camera_list[1][1].visible = true
		camera_list[1][0].visible = false
		audio.play()
	else: 
		camera_list[1][1].visible = false
		camera_list[1][0].visible = true
		audio.stop()
	cameras[0].visible = false
	cameras[1].visible = true
	cameras[2].visible = false

func _on_button_3_pressed() -> void:
	if cam3_broke == true:
		camera_list[2][1].visible = true
		camera_list[2][0].visible = false
		audio.play()
	else: 
		camera_list[2][1].visible = false
		camera_list[2][0].visible = true
		audio.stop()
	cameras[0].visible = false
	cameras[1].visible = false
	cameras[2].visible = true
