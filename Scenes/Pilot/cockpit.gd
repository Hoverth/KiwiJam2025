extends Node2D

var current_altitude: int
var target_altitude: int
var tilt_angle: int
var tilt_direction = 1

func _ready():
	current_altitude = 30000
	
func _process(delta):
	if Input.is_action_pressed('up'):
		current_altitude += 10
		tilt_direction = 1
		tilt_angle = 0
	else: if Input.is_action_pressed("down"):
		current_altitude += -10
		tilt_direction = -1
		tilt_angle = 0
	else: 
		current_altitude += (tilt_angle * tilt_direction)

func _on_tilt_timer_timeout() -> void:
	tilt_angle += 10
