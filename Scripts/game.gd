extends Control

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
	
signal targetAltitudeChanged(newAltitude)

func _ready() -> void:
	# Spawn the seperate scenes and start timer coroutines
	if(is_multiplayer_authority()):
		winTimer.one_shot = true
		winTimer.timeout.connect(win)
		winTimer.start(winTime)
		var instance :Node = load("res://Scenes/Pilot/Cockpit.tscn").instantiate()
		instance.set_multiplayer_authority(MultiplayerRoom.host_id)
		currentAltitude = 30000
		targetAltitude = 30000
		add_child(instance)
		randomAltitudeChange()
	else:
		var instance :Node = load("res://Scenes/Controller/Station.tscn").instantiate()
		instance.set_multiplayer_authority(MultiplayerRoom.host_id)
		add_child(instance)


func _process(delta: float) -> void:
	
	if !is_multiplayer_authority():
		return
	
	percentageTimeRemaining = (1 - (winTimer.time_left/winTime)) * 100
	if (not winTimer.is_stopped()):
		print(winTimer.time_left)
		print(percentageTimeRemaining)
		
	if !gracePeriodActive:
		if currentAltitude >= getMaxAltitude() || currentAltitude <= getMinAltitude():
				gameOver()		

func gracePeriodTimer():
	gracePeriodActive = true
	await get_tree().create_timer(gracePeriodTime).timeout  
	gracePeriodActive = false


	
func randomAltitudeChange():
	await get_tree().create_timer(randomAltitudeChangeTime).timeout
	gracePeriodTimer()
	var rng = RandomNumberGenerator.new()
	if(rng.randi_range(0,1)):
		currentAltitude += rng.randi_range(5000,10000)
	else:
		currentAltitude -= rng.randi_range(5000,10000)
	randomAltitudeChange()

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
	# digits. ee

	return output

func getMinAltitude():
	return targetAltitude - altitude_buffer

func getMaxAltitude():
	return targetAltitude + altitude_buffer

func gameOver():
	MultiplayerSync.change_scene("res://Scenes/GameOver.tscn")

func win():
	print("YOU WON THE GAME")
	
