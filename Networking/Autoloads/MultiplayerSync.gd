extends Node


var current_scene = "res://scenes/UI/JoinMenu.tscn"
signal peerLoaded(id)
func _ready() -> void:
	multiplayer.peer_connected.connect(connectedToHost)

func connectedToHost(id) -> void:
	if !(id == MultiplayerRoom.host_id):
		return
	print("REQUESTING DATA")
	requestGameData.rpc_id(int(MultiplayerRoom.host_id))

@rpc("any_peer","call_remote","reliable")
func requestGameData():
	var sender_id = multiplayer.get_remote_sender_id()
	var dictToSend = {}
	Recursive_child(get_tree().root,dictToSend)
	getGameData.rpc_id(sender_id,dictToSend,current_scene)
	

func Recursive_child(node,dict):
	for child:Node in node.get_children():
		var networkDataTemp = child.get_node_or_null("NetworkData") 
		if networkDataTemp:
			var networkData = networkDataTemp as NetworkData
			dict[child.get_path()] = {
				"name":child.name,
				"file_path":networkData.filePath,
				"parent_path":child.get_parent().get_path(),
				"authority":child.get_multiplayer_authority()
			}
		Recursive_child(child,dict)

@rpc("any_peer","call_remote","reliable")
func getGameData(dictionary:Dictionary,incoming_scene:String):
	print("RECEIVING GAME DATA")
	var error
	if(current_scene != incoming_scene):
		error = get_tree().change_scene_to_file(incoming_scene)
	await get_tree().create_timer(1).timeout
	if(error == OK):
		print(dictionary)
		build_scene(dictionary)


func build_scene(dictionary:Dictionary):
	for node_path in dictionary:
		var new_node = dictionary[node_path]
		var parent = get_node_or_null(new_node.parent_path)
		if !parent:
			print("MISSING PARENT")
			continue
		var nodeExists = get_node_or_null(node_path)
		if nodeExists:
			print("NODE ALREADY EXISITS")
			continue
		var object_to_spawn = load(new_node.file_path)
		var object_instance = object_to_spawn.instantiate() as Node2D
		object_instance.name = new_node.name
		object_instance.set_multiplayer_authority(new_node.authority)
		parent.add_child(object_instance)
	finished_loading.rpc();

@rpc("any_peer","call_remote","reliable")
func finished_loading():
	peerLoaded.emit(multiplayer.get_remote_sender_id())
		
func spawn(file_path,parent_path,authority):
	var load = load(file_path)
	var object :Node2D= load.instantiate();
	var parent = get_node(parent_path)
	
	object.name = generateName()
	object.set_multiplayer_authority(multiplayer.get_unique_id());
	parent.add_child(object,false)
	spawn_rpc.rpc(file_path,parent_path,authority,object.name)
	return object
	


@rpc("any_peer","call_remote","reliable")
func spawn_rpc(file_path,parent_path,authority,object_name):
	var load = load(file_path)
	var object :Node2D= load.instantiate();
	var parent = get_node(parent_path)
	object.name = object_name
	object.set_multiplayer_authority(multiplayer.get_remote_sender_id());
	parent.add_child(object,false)
	await get_tree().create_timer(1).timeout
	if(authority == multiplayer.get_unique_id()):
		set_object_authority(object,authority)

func generateName() -> String:
	var rng = RandomNumberGenerator.new()
	return "%d" % [rng.randf_range(0, 100000.0)]

func set_object_authority(node:Node,new_peer_id):
	set_object_authority_rpc.rpc(node.get_path(),node.get_multiplayer_authority(),new_peer_id)
	
@rpc("any_peer","call_local","reliable")
func set_object_authority_rpc(node_path,old_peer_id,new_peer_id):
	var node = get_node(node_path)
	if node.get_multiplayer_authority() == old_peer_id:
		node.set_multiplayer_authority(new_peer_id,false)
	for child:Node in node.get_children():
		if child.get_multiplayer_authority() == old_peer_id:
			child.set_multiplayer_authority(new_peer_id,false)
			set_object_authority_rpc(child.get_path(),old_peer_id,new_peer_id)


func change_scene(scene_path):
	change_scene_rpc.rpc(scene_path)

@rpc("any_peer","call_local","reliable")
func change_scene_rpc(scene_path):
	current_scene = scene_path
	get_tree().change_scene_to_file(scene_path)

		
	
