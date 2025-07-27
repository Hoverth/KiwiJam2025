extends Node2D

@export var max_altitude := 7000.0
@export var min_altitude := 5000.0


@export var max_altitude_y := -120.0
@export var min_altitude_y := 120.0

var GameManager : Game
var targetAltitude

func _ready():
	var tempParent = self.get_parent()
	if tempParent is Game:
		GameManager = tempParent

	if GameManager != null:
		GameManager.targetAltitudeChanged.connect(onTargetAltitudeChange)


func onTargetAltitudeChange(newAltiitude):
	targetAltitude = newAltiitude
	max_altitude = GameManager.getMaxAltitude()
	min_altitude = GameManager.getMinAltitude()
	
func _process(_delta: float) -> void:
	$AltitudeMeter/Doodads/DeathZone1/Label.text = "%d ft" % round(max_altitude)
	$AltitudeMeter/Doodads/DeathZone2/Label.text = "%d ft" % round(min_altitude)
	$AltitudeMeter/Doodads/PlaneMarker/Label.text = "%d ft" % round(GameManager.currentAltitude)

	var altitude_ratio = (GameManager.currentAltitude - min_altitude) / (max_altitude - min_altitude)

	$AltitudeMeter/Doodads/PlaneMarker.position.y = lerp(min_altitude_y, max_altitude_y, altitude_ratio)
	$Progress.progress = GameManager.percentageTimeRemaining / 100.0

	var cooked := altitude_ratio >= 0.8 or altitude_ratio <= 0.2
	$NoiseAnim.current_animation = "noise_bad" if cooked else "noise"

	$Tablet.is_vibrating = GameManager.camerasBroken


func _on_bird_strike_game_game_over() -> void:
	GameManager.gameOver("Bird strike took out the engines")
