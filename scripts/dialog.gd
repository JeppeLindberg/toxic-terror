extends MarginContainer

@export var text_panel: Panel
@export var text_panel_sprite: Node2D
@export var text: RichTextLabel
@export var speaker_text: RichTextLabel
@export var base_symbols_per_sec = 30.0

var current_dialog = {}
var symbols_per_sec = 0.0
var time_progress = 0.0
var ready_for_next_text = false
var recursion_block = false
var current_scene = ''

signal finish_dialog_signal

	

func is_in_dialog():
	return current_dialog != {}

func _process(delta: float) -> void:
	recursion_block = false
	_update(delta)

func _update(delta):
	text_panel.visible = is_in_dialog() and (_current_dialog()['text'] != '')
	# text_panel_sprite.visible = text_panel.visible
	time_progress += delta * symbols_per_sec
	if is_in_dialog():
		speaker_text.set_text_raw(_current_dialog()['speaker'])
		text.set_text_raw(_current_dialog()['text'], int(time_progress))
		
		if text.all_symbols_visible:
			ready_for_next_text = true
	
		if Input.is_action_just_pressed("interact") and (not recursion_block):
			recursion_block = true
			if ready_for_next_text:
				finish_dialog()
			elif time_progress > 1.0:
				time_progress += 1000.0
	
func finish_dialog():
	current_dialog = {}

	time_progress = 0.0
	symbols_per_sec = base_symbols_per_sec
	ready_for_next_text = false

	finish_dialog_signal.emit()
	
func set_current_dialog(new_current_dialog):
	current_dialog = new_current_dialog

	time_progress = 0.0
	symbols_per_sec = base_symbols_per_sec
	ready_for_next_text = false

func _current_dialog():
	var defaults = \
	{
		'speaker': '',
		'text': '',
	}

	var ret = defaults
	if current_dialog.get('speaker') != null:
		ret['speaker'] = current_dialog['speaker']
	if current_dialog.get('text') != null:
		ret['text'] = current_dialog['text']

	return ret;
