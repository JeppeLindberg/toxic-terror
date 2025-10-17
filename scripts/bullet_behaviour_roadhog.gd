extends Node2D


var added_movement = Vector2.ZERO

@onready var main = get_node('/root/main')
@onready var player = get_node('/root/main/player')
@onready var bullets = get_node('/root/main/bullets')

@export var speed = 130.0
@export var spread_after_secs = 3.0
@export var spread = 0.2

@export var no_of_pellets = 8
@export var pellet: PackedScene

var spawn_time = 0.0

func _ready() -> void:
	spawn_time = main.seconds()

func _process(_delta: float) -> void:
	var bullet_to_player_vec = (player.global_position - global_position).normalized()

	added_movement = bullet_to_player_vec * speed

	if main.seconds() > (spawn_time + 1):
		var time_charge = main.seconds() - (spawn_time + 1)
		for child in get_children():
			var new_pellet = pellet.instantiate()
			new_pellet.direction = bullet_to_player_vec + (child.position).normalized() * spread
			bullets.add_child(new_pellet)
			new_pellet.global_position = child.global_position
			new_pellet.time_charge = time_charge
			new_pellet.move()
		get_parent().queue_free()
