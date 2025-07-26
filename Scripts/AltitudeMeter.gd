extends Node2D

@export var max_altitude := 7000.0
@export var min_altitude := 5000.0

@export var altitude := 7000.0

@export var max_altitude_y := -120.0

@export var min_altitude_y := 120.0

func _process(delta: float) -> void:
	$Doodads/DeathZone1/Label.text = "%d ft" % round(max_altitude)
	$Doodads/DeathZone2/Label.text = "%d ft" % round(min_altitude)
	$Doodads/PlaneMarker/Label.text = "%d ft" % round(altitude)

	var altitude_ratio := (altitude - min_altitude) / (max_altitude - min_altitude)

	$Doodads/PlaneMarker.position.y = lerp(min_altitude_y, max_altitude_y, altitude_ratio)
