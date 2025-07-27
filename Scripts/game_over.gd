extends Control


@onready var ReasonText = GameOverReason.gameOverReason
func _ready() -> void:
	$ReasonLabel.text = ReasonText
	if(is_multiplayer_authority()):
		$Button.disabled = false
		
func _on_button_pressed() -> void:
	MultiplayerSync.change_scene("res://Scenes/Lobby.tscn")
