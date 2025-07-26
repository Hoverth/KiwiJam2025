extends Control


func _on_button_pressed() -> void:
	MultiplayerSync.change_scene("res://Scenes/Lobby.tscn")
