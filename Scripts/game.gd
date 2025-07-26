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

func receivedNewAltitude(newAltitude):
	targetAltitude = newAltitude # remember to set var to new value
	altitudeLabel.text = "TARGET ALTITUDE : %s ft" % [format_number(targetAltitude)]
	
