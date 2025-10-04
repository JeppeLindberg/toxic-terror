extends Area2D

@onready var enemy_pos_1 = get_node('/root/main/camera_pivot/enemy_pos_1')
@onready var enemy_pos_2 = get_node('/root/main/camera_pivot/enemy_pos_2')
@onready var ui = get_node('/root/main/ui')
@onready var main = get_node('/root/main')

var target_pos = null

@export var move_speed = 20.0
@export var max_health = 100.0

@onready var _current_health = max_health
var damage_taken_dec
var current_health_dec = 1.0


func _ready() -> void:
	add_to_group('enemy')

	target_pos = enemy_pos_1;
	
	for child in main.get_children_in_group(self, 'behaviour'):
		if child.activate_at_dec == 1.0:
			child.activate()
			return;


func _process(delta: float) -> void:
	if target_pos != null:
		global_position +=( target_pos.global_position - global_position).normalized() * move_speed*delta
		if target_pos.global_position.distance_to(global_position) < 5.0:
			if target_pos == enemy_pos_1:
				target_pos = enemy_pos_2
			else:
				target_pos = enemy_pos_1

func hit(damage = 1.0):
	var prev_dec = _current_health/max_health
	_current_health -= damage * damage_taken_dec
	ui.enemy_health.set_health_dec(_current_health/max_health)
	var new_dec = _current_health/max_health
	
	current_health_dec = clamp(new_dec, 0.0, 1.0)

	for child in main.get_children_in_group(self, 'behaviour'):
		if new_dec <= child.activate_at_dec and child.activate_at_dec < prev_dec:
			child.activate()
			return;



