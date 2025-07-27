extends Node2D

@export var target_pos := Vector2.ZERO
@export var bird_speed := 5.0

var is_exploded := false

func _process(delta: float) -> void:
	if is_exploded and not $ExplodeAnim.is_playing():
		queue_free()
	else:
		var towards_origin: Vector2 = -position.normalized()
		position += towards_origin * delta * bird_speed

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		explode()

func explode():
	if not is_exploded:
		$Area2D.process_mode = PROCESS_MODE_DISABLED
		$ExplodeAnim.play("explosion")
		is_exploded = true
