extends Control

@onready var PlayerName = "" 
@onready var RoomCode = ""
var webSocketBridge : WebsocketBridge
func _ready() -> void:
	if BridgeHandler.WebsiteBridgeEnabled:
		MultiplayerSync.change_scene("res://scenes/UI/levelSelect.tscn")
	else:
		webSocketBridge = BridgeHandler.currentBridge
		webSocketBridge.HostSuccess.connect(on_host_success)



func _on_host_pressed() -> void:
	webSocketBridge.host_room(PlayerName)
	pass # Replace with function body.

func _on_join_pressed() -> void:
	webSocketBridge.join_room(RoomCode,PlayerName)
	pass # Replace with function body.

func on_host_success():
	MultiplayerSync.change_scene("res://Lobby.tscn")


func _on_name_text_changed(new_text: String) -> void:
	PlayerName = new_text


func _on_room_code_text_changed(new_text: String) -> void:
	RoomCode = new_text
	pass # Replace with function body.
