extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		var is_windowed := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_windowed else DisplayServer.WINDOW_MODE_WINDOWED)
