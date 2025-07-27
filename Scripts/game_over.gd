extends Control


func _ready() -> void:
	$ReasonLabel.text = GameOverReason.gameOverReason
func _on_button_pressed() -> void:
	MultiplayerSync.change_scene("res://Scenes/Lobby.tscn")
