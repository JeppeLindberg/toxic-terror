extends Node2D

@export var seconds_per_lap = 8.0

@onready var main = get_node('/root/main')


func _process(_delta: float) -> void:
	rotation_degrees = (main.seconds() * 360.0) * (1.0 / seconds_per_lap)
