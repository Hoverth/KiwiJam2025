extends Control

@onready var PlayerName = "" 
@onready var RoomCode = ""

var webSocketBridge : WebsocketBridge
func _ready() -> void:
	if BridgeHandler.WebsiteBridgeEnabled:
		MultiplayerSync.change_scene("res://Scenes/Lobby.tscn")
	else:
		webSocketBridge = BridgeHandler.currentBridge
		webSocketBridge.HostSuccess.connect(on_host_success)


func _on_host_pressed() -> void:
	webSocketBridge.host_room(PlayerName)
	pass # Replace with function body.

func _on_join_pressed() -> void:
	webSocketBridge.join_room(RoomCode.to_upper(),PlayerName)
	pass # Replace with function body.

func on_host_success():
	MultiplayerSync.change_scene("res://Scenes/Lobby.tscn")


func _on_name_text_changed(new_text: String) -> void:
	PlayerName = new_text
	
	if (PlayerName != "" && RoomCode == ""):
		$Panel/VBoxContainer/HBoxContainer/Host.visible = true
		$Panel/VBoxContainer/HBoxContainer/Join.visible = false
		$Panel.visible = true
	elif (PlayerName != "" && RoomCode != ""):
		$Panel/VBoxContainer/HBoxContainer/Host.visible = true
		$Panel/VBoxContainer/HBoxContainer/Join.visible = true
		$Panel.visible = true
	else:
		$Panel/VBoxContainer/HBoxContainer/Host.visible = false
		$Panel/VBoxContainer/HBoxContainer/Join.visible = false
		$Panel.visible = false
		
func _on_room_code_text_changed(new_text: String) -> void:
	RoomCode = new_text
	
	# if the text has been changed for both player name
	# and room code, make the join button visible.
	# if either field goes from having occupied fields 
	# back to empty, disable the join button.
	
	if (RoomCode == "") and (PlayerName != ""):
		$Panel/VBoxContainer/HBoxContainer/Host.visible = true
		$Panel/VBoxContainer/HBoxContainer/Join.visible = true

	if (RoomCode != "") and (PlayerName != ""):
		$Panel/VBoxContainer/HBoxContainer/Join.visible = true
		$Panel/VBoxContainer/HBoxContainer/Host.visible = false
	else:
		if (PlayerName != "" && RoomCode == ""):
			$Panel/VBoxContainer/HBoxContainer/Host.visible = true
			$Panel/VBoxContainer/HBoxContainer/Join.visible = false
			$Panel.visible = true
		elif (PlayerName != "" && RoomCode != ""):
			$Panel/VBoxContainer/HBoxContainer/Host.visible = true
			$Panel/VBoxContainer/HBoxContainer/Join.visible = true
			$Panel.visible = true
		else:
			$Panel/VBoxContainer/HBoxContainer/Host.visible = false
			$Panel/VBoxContainer/HBoxContainer/Join.visible = false
			$Panel.visible = false
