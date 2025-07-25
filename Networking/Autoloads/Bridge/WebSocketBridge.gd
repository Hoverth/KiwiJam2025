extends Node
class_name WebsocketBridge
@onready var ws : WebSocketPeer = WebSocketPeer.new()


signal JoinSuccess()
signal JoinFailed(ErrorMsg)
signal HostSuccess()
signal HostFailed(ErrorMsg)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#ws.connect_to_url("wss://127.0.0.1:25566",TLSOptions.client_unsafe())
	ws.connect_to_url("wss://websocket.henry.games",TLSOptions.client_unsafe())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ws.poll()
	if(ws.get_available_packet_count()):
		var string = ws.get_packet().get_string_from_ascii()
		var json = JSON.parse_string(string)
		print(json)
		received_packet(json)
	if ws.get_ready_state() == WebSocketPeer.STATE_OPEN:
		pass
		#var msg = "Hello"
		#ws.put_packet(msg.to_ascii_buffer())
	if ws.get_ready_state() == WebSocketPeer.STATE_CONNECTING:
		print("CONNECTING")
	if ws.get_ready_state() == WebSocketPeer.STATE_CLOSED:
		print("CLosed %s %s"%[ws.get_close_code(),ws.get_close_reason()])
	pass


func host_room(playerName):
	var msg = {
		"code":"HOST",
		"name":playerName
	}
	send_message(msg)
	print("HOSTING")

func join_room(room_code,playerName):
	var msg = {
		"code":"JOIN",
		"room_code":room_code,
		"name":playerName
	}
	send_message(msg)
	print("JOINING")

func received_packet(message):
	match message.code:
		"CONNECTION_SUCCESS":
			BridgeHandler.INIT.emit(message.id)
			MultiplayerRoom.my_id = message.id
			
		"HOST_SUCCESS":
			
			MultiplayerRoom.clearRoom()
			MultiplayerRoom.host_id = MultiplayerRoom.my_id;
			MultiplayerRoom.AddPlayer(MultiplayerRoom.my_id,message.name)
			MultiplayerSync.set_object_authority(get_tree().root,MultiplayerRoom.my_id)
			MultiplayerRoom.room_code = message.room_code
			HostSuccess.emit()
		"JOIN_SUCCESS":
			var authority_set = false;
			MultiplayerRoom.clearRoom()
			MultiplayerRoom.room_code = message.room_code
			for player in message.room:
				MultiplayerRoom.AddPlayer(player.id,player.name)
				if !authority_set:
					MultiplayerRoom.host_id = player.id
					print("AUTHORITY BEING SET")
					print(player.id)
					MultiplayerSync.set_object_authority(get_tree().root,player.id)
					authority_set = true
				if(player.id == MultiplayerRoom.my_id):
					continue
				BridgeHandler.peerJoined.emit(player.id,false)
			JoinSuccess.emit()
		"PLAYER_JOINED":
			MultiplayerRoom.AddPlayer(message.id,message.name)
			BridgeHandler.peerJoined.emit(message.id,true)
		"PLAYER_LEFT":
			MultiplayerRoom.RemovePlayer(message.id)
			if (message.id == MultiplayerRoom.host_id):
				var authority_set = false;
				for player in message.room:
					if !authority_set:
						MultiplayerRoom.host_id = int(player.id)
						MultiplayerSync.set_object_authority(get_tree().root,player.id)
						authority_set = true
						break;
					
				
		"JOIN_FAILED":
			print("JOIN FAILED")
			pass
		"ice":
			BridgeHandler.iceComing.emit(message.mid,message.index,message.sdp,message.sender_id)
		"session":
			BridgeHandler.sessionComing.emit(message.type,message.sdp,message.sender_id)

func send_message(message):
	ws.put_packet(JSON.stringify(message).to_ascii_buffer())
	
func send_message_relay(message,target_id):
	message["id"] = target_id
	ws.put_packet(JSON.stringify(message).to_ascii_buffer())
