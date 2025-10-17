extends Node2D

@onready var bullets = get_node('/root/main/bullets')
@onready var pattern = get_node_or_null('pattern')
@onready var main = get_node('/root/main')
@onready var player = get_node('/root/main/player')
@onready var manager = get_node('/root/main/manager')

@export var bullet: PackedScene
@export var base_bullets_per_sec = 5.0
var _bullets_per_sec = 5.0
@export var x_follow_player = false
@export var base_charge_dec = 0.0
@export var scale_bullets_per_sec_w_damage_taken = false
var scale_bullets_per_sec_w_damage_taken_node = null

var time_charge = 0.0
var index = 0
var emit = false


func _ready() -> void:
	add_to_group('bullet_emitter')

	_bullets_per_sec = base_bullets_per_sec

	if scale_bullets_per_sec_w_damage_taken:
		var node = self
		while node.get('current_health_dec') == null:
			node = node.get_parent()
			if node == main:
				scale_bullets_per_sec_w_damage_taken = false
				return

		scale_bullets_per_sec_w_damage_taken_node = node

func _current_pattern():
	var result = []
	for p in _current_pattern_helper():
		result.append(p.rotated(global_rotation))
	return result

func _current_pattern_helper():
	if pattern == null:
		return [Vector2.RIGHT]
	
	if index >= len(pattern.pattern):
		index = 0

	var current_pattern = pattern.pattern[index]
	
	if current_pattern['type'] == 'vec':
		return current_pattern['vectors']

	if current_pattern['type'] == 'deg':
		if current_pattern.get('bullet_count') == null:
			current_pattern['bullet_count'] = 1000
		if current_pattern.get('base') == null:
			current_pattern['base'] = Vector2.RIGHT

		var result = []
		var deg = 0.0
		var count = 0
		deg += current_pattern['offset']
		while deg < (360.0 + current_pattern['offset']) and count < current_pattern['bullet_count']:
			result.append(current_pattern['base'].rotated(deg_to_rad(deg)))
			deg += current_pattern['degree']
			count += 1
		return result
	
	return [Vector2.RIGHT]


func _process(delta: float) -> void:
	if x_follow_player:
		look_at(player.global_position)

	var calc_bullets_per_sec = _bullets_per_sec

	if scale_bullets_per_sec_w_damage_taken:
		calc_bullets_per_sec *= 1.0 - scale_bullets_per_sec_w_damage_taken_node.current_health_dec

	if not manager.simulate or not emit:
		time_charge = base_charge_dec * (1.0 / calc_bullets_per_sec)
		return

	time_charge += delta

	while time_charge > (1.0 / calc_bullets_per_sec):
		time_charge -= (1.0 / calc_bullets_per_sec)

		for p in _current_pattern():
			var new_bullet = bullet.instantiate()
			bullets.add_child(new_bullet)
			new_bullet.global_position = global_position
			new_bullet.time_charge = time_charge
			new_bullet.direction = p.normalized()
			new_bullet.move()

		index += 1
