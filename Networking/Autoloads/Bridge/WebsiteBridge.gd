extends Node

var room
var room_code



@onready var console = JavaScriptBridge.get_interface("console")

@onready var window = JavaScriptBridge.get_interface("window")
@onready var _on_message_ref = JavaScriptBridge.create_callback(_on_message)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	window.onmessage = _on_message_ref
	console.log("JAVASCRIPT BRIDGE LOADED");
	var jsData = JavaScriptBridge.create_object("Object");
	jsData["code"] = "frame_loaded"
	window.parent.postMessage(jsData);
	#get_viewport().focus_entered.connect(_on_window_focus_in)
	pass # Replace with function body.
	
# Needs testing
#func _on_window_focus_in():
	#print(multiplayer.get_peers())
	#for player_name in room.players:
		#var player = room.players[player_name] 
		#if(player.webRTCID == id):
			#continue
		#if multiplayer.get_peers().has(player.webRTCID):
			#continue
		#print("here")
		#peerJoined.emit(player.webRTCID,true)
		



func _on_message(args):
	var data = JSON.parse_string(args[0].data)
	received_packet(data)

func received_packet(message):
	match message.code:
		"INIT":
			BridgeHandler.INIT.emit(message.id)
			MultiplayerRoom.my_id = message.id
			init_room(message.room)
			
		"room_state_changed":
			room_state_change(message.room)
		"ice":
			BridgeHandler.iceComing.emit(message.mid,message.index,message.sdp,message.sender_id)
		"session":
			BridgeHandler.sessionComing.emit(message.type,message.sdp,message.sender_id)
			
func init_room(new_room):
	MultiplayerRoom.clearRoom()
	MultiplayerRoom.room_code = new_room.roomCode
	var send_offer = false
	var authoritySet = false
	for player_name in new_room.players:
		var player = new_room.players[player_name] 
		MultiplayerRoom.AddPlayer(player.webRTCID,player_name)
		if(!authoritySet):
			MultiplayerRoom.host_id = player.webRTCID
			MultiplayerSync.set_object_authority(get_tree().root,player.webRTCID)
			authoritySet = true
		if(player.webRTCID == MultiplayerRoom.my_id):
			send_offer = true
			continue
		BridgeHandler.peerJoined.emit(player.webRTCID,send_offer)
	room = new_room
	pass

func room_state_change(new_room):
	MultiplayerRoom.clearRoom()
	MultiplayerRoom.room_code = new_room.roomCode
	var send_offer = false
	var authoritySet = false
	for player_name in new_room.players:
		var player = new_room.players[player_name] 
		MultiplayerRoom.AddPlayer(player.webRTCID,player_name)
		if(!authoritySet):
			MultiplayerRoom.host_id = MultiplayerRoom.my_id;
			MultiplayerSync.set_object_authority(get_tree().root,player.webRTCID)
			authoritySet = true
		if(player.webRTCID == MultiplayerRoom.my_id):
			send_offer = true
			continue
		if player in room.players:
			continue
		BridgeHandler.peerJoined.emit(player.webRTCID,send_offer)
	room = new_room

func send_message_relay(Data,targetWebRTCID):
	var jsData = JavaScriptBridge.create_object("Object");
	for property in Data:
		jsData[property] = Data[property]
	
	var targetID;
	for player_name in room.players:
		var player = room.players[player_name]
		if player.webRTCID == targetWebRTCID:
			targetID = player.id;
	
	var bundledData = JavaScriptBridge.create_object("Object");
	bundledData["code"] = "relayTarget"
	bundledData["targetID"] = targetID
	bundledData["data"] = jsData
	window.parent.postMessage(bundledData);





	
