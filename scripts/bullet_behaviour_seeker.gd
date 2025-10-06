extends Node2D


var added_movement = Vector2.ZERO

@onready var main = get_node('/root/main')
@onready var player = get_node('/root/main/player')

@export var speed = 600.0


func _process(_delta: float) -> void:
	var x = main.seconds() * 10
	var y = main.seconds() * 10

	var perlin_vec = Vector2(main.noise_perlin.get_noise_2d(x, y), main.noise_perlin.get_noise_2d(-x, y)).normalized()
	var bullet_to_player_vec = (player.global_position - global_position).normalized()

	added_movement = (perlin_vec * 0.2 + bullet_to_player_vec * 0.8) * speed
