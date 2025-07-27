extends Node

class_name Game



@export var gracePeriodActive = false
@export var gracePeriodTime = 5

@export var winTime : int = 120
@export var percentageTimeRemaining : int
@export var winTimer : Timer
@export var altitude_buffer : int  = 10000

@export var currentAltitude : int
@export var randomAltitudeChangeTime : int = 10
@export var targetAltitude = 30 :
	set = receivedNewAltitude


@export var camera1Broken = false 
@export var camera2Broken = false
@export var camera3Broken = false
@export var cameraDeathTime : int = 20
@export var camerasBroken  = false
@export var eventRunning = false
@export var eventRenewTimer : int = 10
var rng = RandomNumberGenerator.new()

signal targetAltitudeChanged(newAltitude)
signal cameraBroken(cameraNum)
signal cameraFixed(cameraNum)
signal lightEvent()
func _ready() -> void:
	# Spawn the seperate scenes and start timer coroutines
	if(is_multiplayer_authority()):
		rng.set_seed(Time.get_ticks_msec())
		winTimer.one_shot = true
		winTimer.timeout.connect(win)
		winTimer.start(winTime)
		var instance :Node = load("res://Scenes/Pilot/Cockpit.tscn").instantiate()
		instance.set_multiplayer_authority(MultiplayerRoom.host_id)
		currentAltitude = 30000
		targetAltitude = 30000
		add_child(instance)
		#randomAltitudeChange()
		#eventCreator()
	else:
		var instance :Node = load("res://Scenes/Controller/Station.tscn").instantiate()
		instance.set_multiplayer_authority(MultiplayerRoom.host_id)
		add_child(instance)


func _process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	percentageTimeRemaining = (1 - (winTimer.time_left/winTime)) * 100
	#if (not winTimer.is_stopped()):
		#print(winTimer.time_left)
		#print(percentageTimeRemaining)
	
	if !gracePeriodActive:
		if currentAltitude >= getMaxAltitude() || currentAltitude <= getMinAltitude():
				gameOver("Out of altitude range for too long")		

func gracePeriodTimer():
	gracePeriodActive = true
	await get_tree().create_timer(gracePeriodTime).timeout  
	gracePeriodActive = false


	
func randomAltitudeChange():
	await get_tree().create_timer(randomAltitudeChangeTime).timeout
	gracePeriodTimer()
	
	if(rng.randi_range(0,1)):
		currentAltitude += rng.randi_range(2000,5000)
	else:
		currentAltitude -= rng.randi_range(2000,5000)
	randomAltitudeChange()

func eventTimer():
	print("STARTING EVENT TIMER")
	var tempEventTime = eventRenewTimer
	if(rng.randi_range(0,1)):
		tempEventTime += rng.randi_range(0,5)
	else:
		tempEventTime -= rng.randi_range(0,5)
	print(tempEventTime)
	await get_tree().create_timer(tempEventTime).timeout  
	print("Event Creating")
	eventCreator()

func eventCreator():
	var chance = rng.randf_range(0,1)
	if(chance>0.33):
		print("CAMERA BERAK")
		cameraBreak()
		pass
	else:
		print("Light Event")
		lightEvent.emit()
		pass
	
	eventRunning = true

func cameraBreak():
	var camera_num = randi_range(1,3)
	print(camera_num)
	match camera_num:
		1:
			camera1Broken = true
		2: 
			camera2Broken = true
		3:
			camera3Broken = true
	camerasBroken = true
	cameraBroken.emit(camera_num)
	startCameraTimer(camera_num)


func startCameraTimer(camera_num):
	$camera_death.wait_time = cameraDeathTime
	$camera_death.start()


func _on_camera_death_timeout() -> void:
	if camera1Broken || camera2Broken || camera3Broken:
		gameOver("Camera Not fixed in time")


func fixCamera(camera_num):
	fixCameraRPC.rpc_id(int(MultiplayerRoom.host_id),camera_num)

@rpc("any_peer","call_remote","reliable")
func fixCameraRPC(camera_num):
	match camera_num:
		1:
			if camera1Broken:
				eventTimer()
				$camera_death.stop()
				camerasBroken = false
			camera1Broken = false
		2: 
			if camera2Broken:
				eventTimer()
				$camera_death.stop()
				camerasBroken = false
			camera2Broken = false
		3:
			if camera3Broken:
				eventTimer()
				$camera_death.stop()
				camerasBroken = false
			camera3Broken = false
	print("CAMERA FIXED")
	print(camera_num)
	cameraFixed.emit(camera_num)
	
	
func receivedNewAltitude(newAltitude):
	targetAltitude = newAltitude # remember to set var to new value
	targetAltitudeChanged.emit(targetAltitude)

func format_number(altitude) -> String:
	# first, convert the altitude number to a string
	var convert_number : String = str(altitude)
	
	# next, initialize output as a empty string that
	# will be formatted via execution of a for loop
	var output : String = ""
	var count  : int = 0

	# going backwards, at each third index, concatenate
	# the digit with a comma before adding it to the output
	
	for i in range(convert_number.length() - 1, -1, -1):
		output = convert_number[i] + output
		count += 1
		if count % 3 == 0 and i != 0:
			output = "," + output
	
	# lastly, output it as a string that is formatted with
	# digits. 

	return output

func getMinAltitude():
	return targetAltitude - altitude_buffer

func getMaxAltitude():
	return targetAltitude + altitude_buffer

func gameOver(gameOverReason):
	GameOverReason.gameOverReason = gameOverReason
	MultiplayerSync.change_scene("res://Scenes/GameOver.tscn")

func win():
	MultiplayerSync.change_scene("res://Scenes/Win.tscn")
	
func _on_first_event_timer_timeout() -> void:
	if(is_multiplayer_authority()):
		eventCreator()
