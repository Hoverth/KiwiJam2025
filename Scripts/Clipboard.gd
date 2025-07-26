extends Area2D

var overlay_on := false

func on_overlay_click() -> void:
	overlay_on = not overlay_on
	$Overlay.visible = overlay_on
	$CollisionShape2D.disabled = overlay_on
	$ClipboardButton/Clipboard.visible = not overlay_on

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed() and not overlay_on:
		on_overlay_click()

func _on_overlay_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed() and overlay_on:
		on_overlay_click()
