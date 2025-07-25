extends Node

var WebsiteBridgeEnabled = false
var WebsocketBridgePrefab = preload("res://Networking/Autoloads/Bridge/WebsocketBridge.tscn")
var WebsiteBridgePrefab = preload("res://Networking/Autoloads/Bridge/WebsiteBridge.tscn")

signal ConnectedToWS(id)
signal INIT(id)
signal iceComing(mid,index,sdp,id)
signal sessionComing(type,sdp,id)
signal peerJoined(id,send_offer)
var currentBridge;
func _ready() -> void:
	if WebsiteBridgeEnabled:
		currentBridge = WebsiteBridgePrefab.instantiate()
		add_child(currentBridge)
	else:
		currentBridge = WebsocketBridgePrefab.instantiate()
		add_child(currentBridge)
		
func send_message_relay(message,target_id):
	currentBridge.send_message_relay(message,target_id)
	
