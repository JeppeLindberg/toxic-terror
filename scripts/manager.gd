extends Node2D

@onready var main = get_node('/root/main')

@export var enemy_spawn_pos: Node2D

@export var lich_1_prefab: PackedScene

var progress = true
var step = -1

@onready var game_script = \
[
	{
		'type': 'spawn_enemy',
		'enemy': lich_1_prefab
	},
	{
		'type': 'simulate'
	},
	{
		'type': 'spawn_enemy',
		'enemy': lich_1_prefab
	},
	{
		'type': 'simulate'
	}
]



func progress_script():
	step += 1

	var current_step = game_script[step]

	if current_step['type'] == 'spawn_enemy':
		var new_enemy = current_step['enemy'].instantiate()
		main.add_child(new_enemy)
		new_enemy.global_position = enemy_spawn_pos.global_position
		new_enemy.spawn_complete.connect(ready_to_progress)
		new_enemy.dead.connect(ready_to_progress)

func ready_to_progress():
	progress = true

func _process(_delta: float) -> void:
	if progress:
		progress = false
		progress_script()
