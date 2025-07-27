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
	
	if (PlayerName != ""):
		
		# case where player name has data and roomcode is empty
		# option here is to just host.
		if (RoomCode == ""):
			$Panel/VBoxContainer/HBoxContainer/Host.visible = true
			$Panel/VBoxContainer/HBoxContainer/Join.visible = false
			$Panel.visible = true
			
		# case where player name has data and roomcode is not empty
		# option here would be to join.
		
		elif (RoomCode != ""):
			$Panel/VBoxContainer/HBoxContainer/Host.visible = false
			$Panel/VBoxContainer/HBoxContainer/Join.visible = true
			$Panel.visible = true
			
	# if both fields are empty, don't show host/join options.
	# as a name is required.
	
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
	
	if (PlayerName != ""):
		
		# if player name is not empty and a code is present
		# allow the user to only join, not host.
		
		if(RoomCode != ""):
			$Panel/VBoxContainer/HBoxContainer/Join.visible = true
			$Panel/VBoxContainer/HBoxContainer/Host.visible = false
			
		# else, if a player name is empty and no code is present
		# only provide the user with the option to host. 
		if(RoomCode == ""):
			$Panel/VBoxContainer/HBoxContainer/Host.visible = true
			$Panel/VBoxContainer/HBoxContainer/Join.visible = false
	
