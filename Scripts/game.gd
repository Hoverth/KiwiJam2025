extends Control

@export var altitudeLabel:Label
@export var targetAltitudeChangeTime : int = 3
@export var targetAltitude = 30 :
	set = receivedNewAltitude
	
func _ready() -> void:
	if(is_multiplayer_authority()):
		targetAltitudeChange()

func targetAltitudeChange():
	print("HERE")
	var rng = RandomNumberGenerator.new()
	targetAltitude = rng.randi_range(10000,50000)
	await get_tree().create_timer(targetAltitudeChangeTime).timeout  
	targetAltitudeChange()

func receivedNewAltitude(newAltitude):
	targetAltitude = newAltitude # remember to set var to new value
	altitudeLabel.text = "TARGET ALTITUDE : %s" % [targetAltitude]
	
