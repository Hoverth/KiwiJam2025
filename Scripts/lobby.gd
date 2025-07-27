extends Control
@export var PlayerResource: PackedScene = preload("res://Scenes/Resources/ClippedBoardingPass.tscn")

@export var RoomCodeDisplay : Label
@export var PlayersDisplay : Control 
@export var startGameButton : Button
func _ready() -> void:
	updateRoomCode()
	updatePlayers()
	MultiplayerRoom.onPlayersChanged.connect(updatePlayers)
	MultiplayerRoom.onRoomCodeChanged.connect(updateRoomCode)
	if(MultiplayerRoom.players.size() > 1 && is_multiplayer_authority()):
		startGameButton.disabled = false
	else:
		startGameButton.disabled = true
	
func updateRoomCode():
	RoomCodeDisplay.text = "%s" % [MultiplayerRoom.room_code]

func updatePlayers():
	var text = ""
	for child in PlayersDisplay.get_children():
		child.queue_free()
		
	for player_id  in MultiplayerRoom.players:
		var player :MultiplayerRoomPlayer = MultiplayerRoom.players.get(player_id)
		var ticket = PlayerResource.instantiate()
		var ticket_name: Label = ticket.get_child(1)
		ticket_name.text = player.playerName
		var ticket_room: Label = ticket.get_child(2)
		ticket_room.text = MultiplayerRoom.room_code
		PlayersDisplay.add_child(ticket)
	
	if(MultiplayerRoom.players.size() > 1 && is_multiplayer_authority()):
		startGameButton.disabled = false
	else:
		startGameButton.disabled = true
		#text += " %s : %s \n" % [player.id,player.playerName]
	#PlayersDisplay.text = text


func _on_start_game_pressed() -> void:
	MultiplayerSync.change_scene("res://Scenes/Game.tscn")
	pass # Replace with function body.
