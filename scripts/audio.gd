extends Node


@export var audio_player_prefab: PackedScene


func play_effect(audio_stream):
	var new_audio_player = audio_player_prefab.instantiate()
	add_child(new_audio_player)
	new_audio_player.stream = audio_stream
	new_audio_player.pitch_scale = randf_range(0.7, 1.3)
	new_audio_player.play()


func play_music(audio_stream):
	var new_audio_player = audio_player_prefab.instantiate()
	add_child(new_audio_player)
	new_audio_player.stream = audio_stream
	new_audio_player.play()
