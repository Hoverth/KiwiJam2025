extends Node2D

var random_walk_range: float = 1000.0
var origin_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	origin_pos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dx = randf_range(-random_walk_range, random_walk_range)
	var dy = randf_range(-random_walk_range, random_walk_range)
	var random_walk = Vector2(dx, dy)
	position = 0.9 * (position + random_walk * delta) + 0.1 * origin_pos
	pass
