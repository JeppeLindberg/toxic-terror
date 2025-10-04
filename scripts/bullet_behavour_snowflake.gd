extends Node2D


var added_movement = Vector2.ZERO

@onready var main = get_node('/root/main')

@export var speed = 100.0


func _process(_delta: float) -> void:
	var x = global_position.x / 10.0 + main.seconds() * 10.0
	var y = global_position.y / 10.0 + main.seconds() * 10.0

	added_movement = Vector2(main.noise_perlin.get_noise_2d(x, y), main.noise_perlin.get_noise_2d(-x, y)) * speed
