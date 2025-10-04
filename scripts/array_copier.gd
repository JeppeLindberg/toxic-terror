extends Node2D

@export var packed_scene: PackedScene

@export var interval = 100.0
@export var count = 10

func _ready() -> void:
	for i in range(count):
		var new_node = packed_scene.instantiate()
		add_child(new_node)
		new_node.position = Vector2.RIGHT * (i - count/2.0) * interval
		



