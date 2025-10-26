extends Node


@onready var main = get_node('/root/main')

@export var audio_player_prefab: PackedScene

var played_effects = []


func _process(_delta: float) -> void:
	_remove_timed_out()
	
func _remove_timed_out():
	for i in range(len(played_effects)):
		if played_effects[i]['timeout'] <= main.seconds():
			played_effects.remove_at(i)
			_remove_timed_out()
			return

func play_effect(audio_stream):
	for effect in played_effects:
		if effect['path'] == audio_stream.resource_path:
			return

	var new_audio_player = audio_player_prefab.instantiate()
	add_child(new_audio_player)
	new_audio_player.stream = audio_stream
	new_audio_player.pitch_scale = randf_range(0.7, 1.3)
	new_audio_player.play()

	played_effects.append({
		'path':audio_stream.resource_path,
		'timeout': main.seconds() + 0.05
	})

func play_music(audio_stream):
	var new_audio_player = audio_player_prefab.instantiate()
	add_child(new_audio_player)
	new_audio_player.stream = audio_stream
	new_audio_player.play()
