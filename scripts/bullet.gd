extends Node2D

@onready var main = get_node('/root/main')
@onready var shape = get_node('shape')

@export_flags_2d_physics var target_layer: int

@export var move_speed = 400.0

var time_charge = 0.0
var direction = Vector2.ZERO

func _process(delta: float) -> void:
	time_charge += delta

	move()

func move():
	if is_queued_for_deletion():
		return

	if (time_charge > 0) and (direction != Vector2.ZERO):
		var nodes = main.get_nodes_in_shape(shape, global_transform, target_layer, direction * move_speed * time_charge)
		if nodes != []:
			nodes[0].hit()
			queue_free()
			return

		global_position += direction * move_speed * time_charge

	time_charge = 0.0
