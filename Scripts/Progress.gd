extends Node2D

@export var progress_x_min := 200.0
@export var progress_x_max := 1000.0

# goes from 0.0 to 1.0
@export var progress := 0.0

@onready var label_template: String = $Label3.text

var elapsed := 0.0
func _process(delta: float) -> void:
	#elapsed += delta
	#progress = 0.5 * sin(elapsed) + 0.5
	#print(progress)

	$Plane.position.x = lerp(progress_x_min, progress_x_max, progress)
	$Node2D.scale.x = progress
	$Label3.text = label_template.replace("{}", str(round(100 * progress)))
