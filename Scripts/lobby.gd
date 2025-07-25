extends Control


@export var RoomCodeDisplay : Label
@export var PlayersDisplay : Label
func _ready() -> void:
	updateRoomCode()
	updatePlayers()
	MultiplayerRoom.onPlayersChanged.connect(updatePlayers)
	MultiplayerRoom.onRoomCodeChanged.connect(updateRoomCode)
	
func updateRoomCode():
	RoomCodeDisplay.text = "Room Code : %s" % [MultiplayerRoom.room_code]

func updatePlayers():
	var text = ""
	for player_id  in MultiplayerRoom.players:
		var player :MultiplayerRoomPlayer = MultiplayerRoom.players.get(player_id)
		text += " %s : %s \n" % [player.id,player.playerName]
	PlayersDisplay.text = text


func _on_start_game_pressed() -> void:
	MultiplayerSync.change_scene("res://Scenes/Game.tscn")
	pass # Replace with function body.
