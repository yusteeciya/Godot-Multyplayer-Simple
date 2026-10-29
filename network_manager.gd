extends Node

const PORT = 7777
const ADDRESS = "127.0.0.1" 

@export var player_scene: PackedScene = preload("res://player.tscn")
@export var world_scene: PackedScene = preload("res://world.tscn")

var world_instance : Node

@export var btn_host: Button
@export var btn_join: Button

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

func _on_btn_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, 32)
	if error != OK: return
	
	multiplayer.multiplayer_peer = peer
	start_game()

func _on_btn_join_pressed():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ADDRESS, PORT)
	if error != OK: return
	
	multiplayer.multiplayer_peer = peer

func _on_player_connected(id):
	spawn_player(id)

func _on_player_disconnected(id):
	var player_node = world_instance.get_node("Players/" + str(id))
	if player_node:
		player_node.queue_free()

func _on_connected_to_server():
	start_game()

func _on_connection_failed():
	print("Connection failed")

func start_game():
	btn_host.hide()
	btn_join.hide()
	
	world_instance = world_scene.instantiate()
	add_child(world_instance)
	
	$MultiplayerSpawner.spawn_path = world_instance.get_node("Players").get_path()
	$MultiplayerSpawner.add_spawnable_scene(player_scene.resource_path)
	
	if multiplayer.is_server():
		spawn_player(1)

func spawn_player(id):
	if not multiplayer.is_server():
		return

	if world_instance.get_node("Players").has_node(str(id)):
		return

	var p = player_scene.instantiate()
	p.name = str(id) 
	p.position = Vector3(randf_range(-2, 2), 2, randf_range(-2, 2))

	world_instance.get_node("Players").add_child(p, true)
