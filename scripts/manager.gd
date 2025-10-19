extends Node2D

@onready var main = get_node('/root/main')

@export var debug_mode = false

@export var enemy_spawn_pos: Node2D
@export var dialog: Control

@export var lich_1_prefab: PackedScene

var progress = true
var step = -1
var simulate = true
var game_ending = false
var fade_out = false

@onready var game_script = \
[
	{
		'type': 'stop_simulate'
	},
	{
		'type': 'spawn_enemy',
		'enemy': lich_1_prefab
	},
	{
		'type': 'dialog',
		'speaker': 'Lich',
		'text': 'Well well well.'
	},
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Lich',
	# 	'text': 'You have chosen your opponent poorly, little magician!'
	# },
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Magician',
	# 	'text': 'Cerberus does not belong to you!'
	# },
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Lich',
	# 	'text': 'I stole it fair and square!'
	# },
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Lich',
	# 	'text': 'And besides'
	# },
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Lich',
	# 	'text': 'I have many more experiments to run on that runt.'
	# },
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Magician',
	# 	'text': 'I will not allow it! Cerberus is coming with me!'
	# },
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Lich',
	# 	'text': 'Do not force my hand!'
	# },
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Lich',
	# 	'text': 'You will hand Cerberus over, or die.'
	# },
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Magician',
	# 	'text': 'No chance!'
	# },
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Lich',
	# 	'text': 'So be it.'
	# },
	{
		'type': 'dialog',
		'speaker': 'TIP',
		'text': 'Use WASD to move. Use [SPACEBAR] to tell Cerberus to sit, and emit a shield. Use [SHIFT] for more accurate control.'
	},
	{
		'type': 'simulate'
	},
	{
		'type': 'stop_simulate'
	},
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Lich',
	# 	'text': 'BAH!'
	# },
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Magician',
	# 	'text': 'This is over, let us leave!'
	# },
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Lich',
	# 	'text': 'YOU THINK THIS IS OVER?'
	# },
	# {
	# 	'type': 'go_to_next_enemy_tier'
	# },
	# {
	# 	'type': 'dialog',
	# 	'speaker': 'Lich',
	# 	'text': 'WE HAVE ONLY JUST BEGUN, CHILD!'
	# },
	# {
	# 	'type': 'simulate'
	# },
	# {
	# 	'type': 'stop_simulate'
	# },
	{
		'type': 'end_game'
	},
	{
		'type': 'dialog',
		'speaker': 'Lich',
		'text': 'Gah... This cannot be.'
	},
	{
		'type': 'destroy_enemy'
	},
	{
		'type': 'dialog',
		'speaker': 'Magician',
		'text': 'Phew...'
	},
	{
		'type': 'dialog',
		'speaker': 'Magician',
		'text': 'I survived.'
	},
	{
		'type': 'dialog',
		'speaker': 'Magician',
		'text': 'He will surely be back though.'
	},
	{
		'type': 'dialog',
		'speaker': 'Magician',
		'text': 'I should leave before he persues me again.'
	},
	{
		'type': 'fade_out'
	},
]



func progress_script():
	step += 1

	var current_step = game_script[step]

	if current_step['type'] == 'stop_simulate':
		simulate = false
		ready_to_progress()

	if current_step['type'] == 'end_game':
		game_ending = true
		ready_to_progress()

	if current_step['type'] == 'fade_out':
		fade_out = true

	if current_step['type'] == 'dialog':
		dialog.set_current_dialog(current_step)
		dialog.finish_dialog_signal.connect(ready_to_progress_signal_reciever)

	if current_step['type'] == 'simulate':
		var enemy = main.get_children_in_group(main, 'enemy')[0]
		enemy.health_depleted.connect(ready_to_progress_signal_reciever)
		simulate = true

	if current_step['type'] == 'destroy_enemy':
		var enemy = main.get_children_in_group(main, 'enemy')[0]
		enemy.destroy()
		dialog.set_current_dialog({
			'speaker': ' ',
			'text': ' '
		})
		dialog.finish_dialog_signal.connect(ready_to_progress_signal_reciever)

	if current_step['type'] == 'spawn_enemy':
		var new_enemy = current_step['enemy'].instantiate()
		main.add_child(new_enemy)
		new_enemy.global_position = enemy_spawn_pos.global_position
		new_enemy.spawn_complete.connect(ready_to_progress_signal_reciever)

	if current_step['type'] == 'go_to_next_enemy_tier':
		var enemy = main.get_children_in_group(main, 'enemy')[0]
		enemy.go_to_next_tier()
		dialog.set_current_dialog({
			'speaker': ' ',
			'text': ' '
		})
		dialog.finish_dialog_signal.connect(ready_to_progress_signal_reciever)


func ready_to_progress_signal_reciever():
	for dict in get_incoming_connections():
		dict['signal'].disconnect(dict['callable'])
	ready_to_progress()

func ready_to_progress():
	progress = true

func _process(_delta: float) -> void:
	if progress:
		progress = false
		progress_script()
