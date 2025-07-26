extends Node2D

var target_altitude: int

@export var gracePeriodTime : int = 5
var gracePeriodActive = false;

var tilt_angle: int
var tilt_direction = 1

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

func cameraBroken(camera_num):
	match camera_num:
		1:
			$Camera.cam1_broke = true
		2:
			$Camera.cam2_broke = true
		3:
			$Camera.cam3_broke = true
func _process(delta):
	if GameManager.gracePeriodActive:
		# Warning Lights and Stuff
		pass
	
	if Input.is_action_pressed('up'):
		GameManager.currentAltitude += 10
		tilt_direction = 1
		tilt_angle = 0
	else: if Input.is_action_pressed("down"):
		GameManager.currentAltitude += -10
		tilt_direction = -1
		tilt_angle = 0
	else: 
		GameManager.currentAltitude += (tilt_angle * tilt_direction)

func _on_tilt_timer_timeout() -> void:
	tilt_angle += 10
