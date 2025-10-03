extends Area2D

@onready var enemy_pos_1 = get_node('/root/main/camera_pivot/enemy_pos_1')
@onready var enemy_pos_2 = get_node('/root/main/camera_pivot/enemy_pos_2')

var target_pos = null

@export var move_speed = 20.0


func _ready() -> void:
	target_pos = enemy_pos_1;

func _process(delta: float) -> void:
	if target_pos != null:
		global_position +=( target_pos.global_position - global_position).normalized() * move_speed*delta
		if target_pos.global_position.distance_to(global_position) < 5.0:
			if target_pos == enemy_pos_1:
				target_pos = enemy_pos_2
			else:
				target_pos = enemy_pos_1

func hit():
	pass
