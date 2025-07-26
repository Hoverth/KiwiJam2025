extends ColorRect

@export var progress_max_px := 312.0
@export var progress := 0.0
# increment per second
@export var progress_speed := 0.1
@export var loss_speed := -0.1
@export var done_color: Color = Color.PALE_GREEN
@onready var original_color: Color = $ProgressRect.color
@export var cameraNum : int
var holding := false

signal done

func reset() -> void:
	var gameManager :Game = get_tree().root.get_node("Game")
	gameManager.fixCamera(cameraNum)
	$ProgressRect.color = original_color
	progress = 0.0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			holding = event.pressed and get_global_rect().has_point(event.position)

func _process(delta: float) -> void:
	if progress < 1.0:
		var speed := progress_speed if holding else loss_speed
		progress = clamp(progress + speed * delta, 0.0, 1.0)
		$ProgressRect.size.x = progress * progress_max_px
		if progress >= 1.0:
			$ProgressRect.color = done_color
			done.emit()
			await get_tree().create_timer(2.0).timeout
			reset()
