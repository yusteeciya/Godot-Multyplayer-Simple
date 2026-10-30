extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003

@onready var camera_boom: Node3D = $CameraBoom

@export var health: int = 100

func _enter_tree():
	var player_id = name.to_int()
	set_multiplayer_authority(player_id)

func _ready():
	add_to_group("players_group")
	
	if is_multiplayer_authority():
		if camera_boom and camera_boom.has_node("Camera3D"):
			camera_boom.get_node("Camera3D").make_current()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		if camera_boom and camera_boom.has_node("Camera3D"):
			camera_boom.get_node("Camera3D").current = false

func _unhandled_input(event):
	if not is_multiplayer_authority(): return

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		if camera_boom:
			camera_boom.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
			camera_boom.rotation.x = clamp(camera_boom.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta):
	if not is_multiplayer_authority(): return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	if Input.is_action_just_pressed("click") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		attack_server.rpc_id(1)

@rpc("any_peer", "call_local", "reliable")
func attack_server():
	var sender_id = multiplayer.get_remote_sender_id()
	if sender_id == 0:
		sender_id = 1

	var all_players = get_parent().get_children()
	
	for other_player in all_players:
		if other_player is CharacterBody3D and other_player.name != str(sender_id):
			other_player.take_damage(20)

func take_damage(amount: int):
	if not multiplayer.is_server(): return 
	
	health -= amount
	print("Player ", name, " take damage! Current HP: ", health)
	if health <= 0:
		print("Player ", name, " die! Start respawn...")
		respawn_player()

func respawn_player():
	health = 100
	
	var random_x = randf_range(-10, 10)
	var random_z = randf_range(-10, 10)
	global_position = Vector3(random_x, 5.0, random_z)
	
	print("Player ", name, " spawned to  ", global_position)
