extends Node

var rtc : WebRTCMultiplayerPeer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("WEBRTC ENABLED")
	BridgeHandler.INIT.connect(onConnected)
	
	BridgeHandler.peerJoined.connect(create_peer)
	BridgeHandler.iceComing.connect(_ice_received)
	BridgeHandler.sessionComing.connect(_session_received)
	multiplayer.peer_connected.connect(_on_player_connected)

	pass # Replace with function body.

func onConnected(id):
	rtc = WebRTCMultiplayerPeer.new()
	var error = rtc.create_mesh(id)
	multiplayer.multiplayer_peer = rtc

func create_peer(id,send_offer):
	print("CREATING PEER")
	var peer: WebRTCPeerConnection = WebRTCPeerConnection.new()
	peer.initialize({
		"iceServers":[
	  {
		"urls": "stun:stun.relay.metered.ca:80",
	  },
	  {
		"urls": "turn:standard.relay.metered.ca:80",
		"username": "af8f1f59de11c3e97b03c0f8",
		"credential": "ML/yLSXp/uy3Qhdv",
	  },
	  {
		"urls": "turn:standard.relay.metered.ca:80?transport=tcp",
		"username": "af8f1f59de11c3e97b03c0f8",
		"credential": "ML/yLSXp/uy3Qhdv",
	  },
	  {
		"urls": "turn:standard.relay.metered.ca:443",
		"username": "af8f1f59de11c3e97b03c0f8",
		"credential": "ML/yLSXp/uy3Qhdv",
	  },
	  {
		"urls": "turns:standard.relay.metered.ca:443?transport=tcp",
		"username": "af8f1f59de11c3e97b03c0f8",
		"credential": "ML/yLSXp/uy3Qhdv",
	  },
  ],
	})

	peer.session_description_created.connect(_on_session.bind(id))
	peer.ice_candidate_created.connect(_on_ice_candidate.bind(id))
	rtc.add_peer(peer, id)
	if(send_offer):
		peer.create_offer()
		

func _on_ice_candidate(mid, index, sdp,id):
	#var jsData = JavaScriptBridge.create_object("Object");
	#jsData["code"] = "ice"
	#jsData["mid"] = mid
	#jsData["index"] = index
	#jsData["sdp"] = sdp
	#jsData["id"] = id
	var msg = {
		"code":"ice",
		"mid":mid,
		"index":index,
		"sdp":sdp,
		"id":id,

	}
	BridgeHandler.send_message_relay(msg,id)

func _ice_received(mid: String, index: int, sdp: String,id: int) -> void:
	if rtc.has_peer(id):
		rtc.get_peer(id).connection.add_ice_candidate(mid, index, sdp)


func _on_session(type, sdp,id):
	rtc.get_peer(id).connection.set_local_description(type, sdp)
	#var jsData = JavaScriptBridge.create_object("Object");
	#jsData["code"] = "session"
	#jsData["type"] = type
	#jsData["sdp"] = sdp
	#jsData["id"] = id
	var msg = {
		"code":"session",
		"type":type,
		"sdp":sdp,
		"id":id,

	}
	BridgeHandler.send_message_relay(msg,id)

func _session_received(type,sdp,id) -> void:
	if rtc.has_peer(id):
		rtc.get_peer(id).connection.set_remote_description(type, sdp)

func _on_player_connected(id):
	print("CONNECTED TO : %d" % [id])
