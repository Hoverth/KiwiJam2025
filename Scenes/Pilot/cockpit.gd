extends Node2D

signal camera_broken
signal camera_fixed

var target_altitude: int

@export var gracePeriodTime : int = 5
var gracePeriodActive = false;

@export var particle_grav_up := 150.0
@export var particle_grav_down := -10.0
@export var particle_grav_still := 40.0

var tilt_angle: int
var tilt_direction = 1
var control_enabled = true

@onready var tilt_timer = $tilt_timer

var GameManager : Game

func _ready():
	var tempParent = self.get_parent()
	if tempParent is Game:
		GameManager = tempParent
		
	if GameManager != null:
		GameManager.cameraBroken.connect(cameraBroken)
		GameManager.cameraFixed.connect(cameraFixed)
		GameManager.lightEvent.connect(startLightEvent)
		pass
	target_altitude = GameManager.targetAltitude

func startLightEvent():
	$EjectSeat.reset(false)
func cameraFixed(camera_num):
	match camera_num:
		1:
			$Camera.cam1_broke = false
		2:
			$Camera.cam2_broke = false
		3:
			$Camera.cam3_broke = false
	camera_fixed.emit(camera_num)

func cameraBroken(camera_num):
	match camera_num:
		1:
			$Camera.cam1_broke = true
		2:
			$Camera.cam2_broke = true
		3:
			$Camera.cam3_broke = true
	camera_broken.emit(camera_num)
func _process(delta):
	if GameManager.gracePeriodActive:
		# Warning Lights and Stuff
		pass

	var particle_grav := particle_grav_still
	if Input.is_action_pressed('up') and control_enabled == true:
		GameManager.currentAltitude += 10
		tilt_direction = 1
		tilt_angle = 0
		particle_grav = particle_grav_up
	else: if Input.is_action_pressed("down") and control_enabled == true:
		GameManager.currentAltitude += -10
		tilt_direction = -1
		tilt_angle = 0
		particle_grav = particle_grav_down
	else: 
		GameManager.currentAltitude += (tilt_angle * tilt_direction)
	$"Clouds?".process_material.gravity.y = particle_grav

func _on_tilt_timer_timeout() -> void:
	tilt_angle += 10

func _on_start_timer_timeout() -> void:
	tilt_timer.start()

func _on_camera_button_camera_toggled() -> void:
	if control_enabled == true:
		control_enabled = false
	else:
		control_enabled = true

func _on_clipboard_overlay_shown() -> void:
	control_enabled = false

func _on_clipboard_overlay_hidden() -> void:
	control_enabled = true
