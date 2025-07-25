extends  Node

var host_id : float
var my_id :float
@onready var room_code : String = "Not Connected To Room" :	
	set(newRoomCode):
		room_code = newRoomCode
		onRoomCodeChanged.emit()
		
@onready var players : Dictionary[float,MultiplayerRoomPlayer] = {}

signal onPlayersChanged()
signal onRoomCodeChanged()
func AddPlayer(id,playerName):
	var newPlayer = MultiplayerRoomPlayer.new()
	newPlayer.id = id
	newPlayer.playerName = playerName
	players.set(id,newPlayer)
	onPlayersChanged.emit()

func RemovePlayer(id):
	players.erase(id);
	onPlayersChanged.emit()

func clearRoom():
	room_code = ""
	host_id = -1
	players = {}

func is_host():
	return my_id == host_id
