extends RigidBody2D

var state = 'idle'
var direction_to_player = Vector2.ZERO

@onready var detect_player_shape = get_node('detect_player_shape')
@onready var stop_move_shape = get_node('stop_move_shape')
@onready var main = get_node('/root/main')
@onready var player = get_node('/root/main/player')
@onready var shield = get_node('shield')

@export var sprite: AnimatedSprite2D
@export var movement_speed : float = 300.0

@export_flags_2d_physics var player_layer: int


func _physics_process(_delta: float) -> void:	
	_update_state()

	direction_to_player = (player.global_position - global_position).normalized()

	if state == 'idle' or state == 'move_toward_player':
		sprite.play('idle')
	if state == 'sit':
		sprite.play('sit')
	if direction_to_player.x < 0:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1

	if (state == 'idle') or (state =='sit'):
		linear_velocity = Vector2.ZERO
		return;

	if state == 'move_toward_player':
		if direction_to_player != Vector2.ZERO:		
			linear_velocity = direction_to_player * movement_speed

func _update_state():
	var nodes = main.get_nodes_in_shape(detect_player_shape, global_transform, player_layer)

	var can_see_player = false
	for node in nodes:
		if node.is_in_group('player'):
			can_see_player = true
			break;

	nodes = main.get_nodes_in_shape(stop_move_shape, global_transform, player_layer)
	
	var should_stop_move = false
	for node in nodes:
		if node.is_in_group('player'):
			should_stop_move = true
			break;

	if not can_see_player and state == 'idle':
		state = 'move_toward_player'
		return;
	
	if state == 'move_toward_player' and should_stop_move:
		state = 'idle'
		return	

func sit():
	if state != 'sit':
		state = 'sit'
		shield.enabled = true
	else:
		state = 'move_toward_player'
		shield.enabled = false
		_update_state()

