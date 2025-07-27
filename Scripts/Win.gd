extends Control

func _ready() -> void:
	if(is_multiplayer_authority()):
		$Button.disabled = false

func _on_button_pressed() -> void:
	MultiplayerSync.change_scene("res://Scenes/Lobby.tscn")
