extends Node2D

@onready var main = get_node('/root/main')
@onready var audio = get_node('/root/main/audio')
@onready var shape = get_node_or_null('shape')
var bullet_behaviour

@export var debug_mode = false

@export_flags_2d_physics var target_layer: int

@export var move_speed = 400.0
@export var max_lifetime = 5.0
@export var use_delta_time = true
@export var spawn_audio: AudioStream = null

var _initialized = false

var time_charge = 0.0
var direction = Vector2.ZERO
var id = 0

var _last_checked_transform: Transform2D
var _despawn_time = 0.0


func _ready() -> void:
	if spawn_audio == null:
		audio.play_effect(main.audio_bullet_lazer)
	else:
		audio.play_effect(spawn_audio)

func _process(delta: float) -> void:
	time_charge += delta

	move()

func move():
	if not _initialized:
		id = main.get_bullet_id()
		_last_checked_transform = global_transform
		_despawn_time = main.seconds() + max_lifetime
		bullet_behaviour = get_node_or_null('bullet_behaviour')
		_initialized = true

	if is_queued_for_deletion():
		return

	if time_charge > 0:
		var check_physics_interval = 2

		var motion = direction * move_speed 
		if bullet_behaviour != null:
			motion += bullet_behaviour.added_movement
		if use_delta_time:
			motion = motion * time_charge

		if (shape != null) and (main.get_frame_id() % check_physics_interval == id % check_physics_interval):
			var nodes = main.get_nodes_in_shape(shape, _last_checked_transform, target_layer, (global_position - _last_checked_transform.origin) + motion)
			if nodes != []:
				nodes[0].hit()
				queue_free()
				return

			global_position += motion
			_last_checked_transform = global_transform
		else:
			global_position += motion

	time_charge = 0.0

	if main.seconds() >= _despawn_time:
		queue_free()
