extends Area2D

var overlay_on := false

# we assume at most one overlay can be open
static var any_overlay_on := false

@export var content: PackedScene

func _ready() -> void:
	if content:
		var content_inst := content.instantiate()
		$Overlay.add_child(content_inst)

func on_overlay_click() -> void:
	overlay_on = not overlay_on
	$Overlay.process_mode = Node.PROCESS_MODE_INHERIT if overlay_on else Node.PROCESS_MODE_DISABLED
	$Overlay.visible = overlay_on
	$CollisionShape2D.disabled = overlay_on
	$Clipboard.visible = not overlay_on
	if overlay_on:
		any_overlay_on = true
	else:
		call_deferred("clear_any_overlay_on")


func clear_any_overlay_on() -> void:
	any_overlay_on = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed() and not overlay_on and not any_overlay_on:
		on_overlay_click()

func _on_overlay_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed() and overlay_on:
		on_overlay_click()
