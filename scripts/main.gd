extends Node2D

@export_flags_2d_physics var basic_layer: int
@export_flags_2d_physics var no_layer: int

@export var music: AudioStream

@export var audio_bullet_lazer: AudioStream

@onready var world = get_node('/root/main')
@onready var debug = get_node('/root/main/debug_ui/debug')
@onready var audio = get_node('/root/main/audio')

var noise_perlin: FastNoiseLite

var _seconds = 0.0
var _delta = 0.0
var _bullet_id = 0
var _frame_id = 0



func _ready() -> void:
	noise_perlin = FastNoiseLite.new()
	noise_perlin.noise_type = FastNoiseLite.TYPE_PERLIN
	audio.play_music(music)

func _process(frame_delta: float) -> void:
	_seconds += frame_delta
	_delta = frame_delta
	_frame_id += 1

func seconds():
	return _seconds

func delta():
	return _delta

func get_bullet_id():
	_bullet_id += 1
	return _bullet_id - 1

func get_frame_id():
	return _frame_id


var _result

func get_children_in_group(node, group):
	_result = []

	_get_children_in_group_recursive(node, group)

	return _result

func _get_children_in_group_recursive(node, group):
	for child in node.get_children():
		if child.is_in_group(group):
			_result.append(child)

		_get_children_in_group_recursive(child, group)

func get_nodes_in_shape(collider, transform, collision_mask = 0, motion = Vector2.ZERO):
	debug.add_draw_line(transform.origin, transform.origin + motion);

	var shape = PhysicsShapeQueryParameters2D.new()
	shape.shape = collider.shape;
	shape.transform = transform
	shape.collide_with_areas = true
	if collision_mask != 0:
		shape.collision_mask = collision_mask
	else:
		shape.collision_mask = basic_layer
	if motion != Vector2.ZERO:
		shape.motion = motion
	var collisions = world.get_world_2d().direct_space_state.intersect_shape(shape);
	if collisions == null:
		return([])
	
	var nodes = []
	for collision in collisions:
		var node = collision['collider']
		nodes.append(node)
	return nodes
