extends Node2D

@onready var camera_list = [[$"Cam 1/State 1", $"Cam 1/State 2", $"Cam 1/State 1 2"],[$"Cam 2/State 1", $"Cam 2/State 2"],[$"Cam 3/State 1", $"Cam 3/State 2"]]
@onready var cameras = [$"Cam 1", $"Cam 2", $"Cam 3"]
@onready var audio = $AudioStreamPlayer2D
var cam1_broke = false
var cam2_broke = false
var cam3_broke = false

func _on_button_pressed() -> void:
	if cam1_broke == true:
		audio.play()
	else: 
		audio.stop()
		if randi_range(1, 10) == 2:
			camera_list[0][2].visible = true
			camera_list[0][0].visible = false
		else:
			camera_list[0][0].visible = true
			camera_list[0][2].visible = false
	cameras[0].visible = true
	cameras[1].visible = false
	cameras[2].visible = false

func _on_button_2_pressed() -> void:
	if cam2_broke == true:
		audio.play()
	else: 
		audio.stop()
	cameras[0].visible = false
	cameras[1].visible = true
	cameras[2].visible = false

func _on_button_3_pressed() -> void:
	if cam3_broke == true:
		audio.play()
	else: 
		audio.stop()
	cameras[0].visible = false
	cameras[1].visible = false
	cameras[2].visible = true


func _on_node_2d_camera_broken(camera_num) -> void:
	camera_list[camera_num - 1][0].visible = false
	camera_list[camera_num - 1][1].visible = true


func _on_node_2d_camera_fixed(camera_num) -> void:
	camera_list[camera_num - 1][0].visible = true
	camera_list[camera_num - 1][1].visible = false
