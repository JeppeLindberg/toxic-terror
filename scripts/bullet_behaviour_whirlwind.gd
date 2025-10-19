extends Node2D


var added_movement = Vector2.ZERO


@onready var main = get_node('/root/main')
@onready var player = get_node('/root/main/player')
@onready var bullets = get_node('/root/main/bullets')

@export var pellet_prefab: PackedScene
@export var rotator : Node2D
@export var speed = 600.0


func _ready():
	for child in rotator.get_children():
		var new_bullet = pellet_prefab.instantiate()
		new_bullet.get_node('bullet_behaviour').target_node = child
		bullets.add_child(new_bullet)
		new_bullet.time_charge = 0.1
		new_bullet.move()

func _process(_delta: float) -> void:

	var bullet_to_player_vec = (player.global_position - global_position).normalized()

	added_movement = bullet_to_player_vec * speed
