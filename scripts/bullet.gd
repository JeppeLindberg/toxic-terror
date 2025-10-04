extends Node2D

@onready var main = get_node('/root/main')
@onready var shape = get_node('shape')
var bullet_behaviour

@export_flags_2d_physics var target_layer: int

@export var move_speed = 400.0
@export var max_lifetime = 5.0

var _initialized = false

var time_charge = 0.0
var direction = Vector2.ZERO
var id = 0

var _last_checked_transform: Transform2D
var _despawn_time = 0.0



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

	if (time_charge > 0) and (direction != Vector2.ZERO):
		var check_physics_interval = 2

		var motion = direction * move_speed 
		if bullet_behaviour != null:
			motion += bullet_behaviour.added_movement
		motion = motion * time_charge

		if main.get_frame_id() % check_physics_interval == id % check_physics_interval:
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
