extends MultiplayerSynchronizer
@onready var parent = get_parent();
func _ready() -> void:
	get_initial_sync.rpc_id(get_multiplayer_authority())
	

@rpc("any_peer","call_remote","reliable")
func get_initial_sync():
	var sender_id = multiplayer.get_remote_sender_id()
	parent.remove_child(self)
	parent.add_child(self)
	
