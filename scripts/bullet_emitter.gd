extends Node2D

@onready var bullets = get_node('/root/main/bullets')
@onready var pattern = get_node_or_null('pattern')

@export var bullet: PackedScene
@export var bullets_per_sec = 5.0

var time_charge = 0.0
var index = 0


func _current_pattern():
	if pattern == null:
		return [Vector2.DOWN]
	
	if index >= len(pattern.pattern):
		index = 0

	var current_pattern = pattern.pattern[index]
	
	if current_pattern['type'] == 'vec':
		return current_pattern['vectors']

	if current_pattern['type'] == 'deg':
		var result = []
		var deg = 0.0
		deg += current_pattern['offset']
		while deg < (360.0 + current_pattern['offset']):
			result.append(current_pattern['base'].rotated(deg_to_rad(deg)))
			deg += current_pattern['degree']
		return result
	
	return [Vector2.DOWN]


func _process(delta: float) -> void:
	time_charge += bullets_per_sec * delta

	while time_charge > 1.0:
		time_charge -= 1.0

		for p in _current_pattern():
			var new_bullet = bullet.instantiate()
			bullets.add_child(new_bullet)
			new_bullet.global_position = global_position
			new_bullet.time_charge = time_charge
			new_bullet.direction = p.normalized()
			new_bullet.move()

		index += 1
