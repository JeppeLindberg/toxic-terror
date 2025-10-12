extends Node2D

@export var sprite: PackedScene
@export var sprite_size_y = 100
@export var sprite_count = 100
@export var track_node: Node2D


func _ready():
	for i in range(sprite_count):
		var new_sprite = sprite.instantiate()
		add_child(new_sprite)

func _process(_delta: float) -> void:
	var no_of_children = get_child_count()
	for i in range(no_of_children):
		var max_y =sprite_size_y * no_of_children
		var y_pos = -(max_y / 2.0) + i * sprite_size_y
		var track_node_y_pos = floor(track_node.global_position.y / sprite_size_y) * sprite_size_y
		get_child(i).global_position.y = y_pos + track_node_y_pos


