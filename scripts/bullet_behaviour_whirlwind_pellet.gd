extends Node2D


var added_movement = Vector2.ZERO


@onready var main = get_node('/root/main')
@onready var player = get_node('/root/main/player')

var target_node = null


func _process(_delta: float) -> void:

	var bullet_to_target_vec = (target_node.global_position - global_position)

	added_movement = bullet_to_target_vec
