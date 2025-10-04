extends Node2D

@onready var main = get_node('/root/main')

@export var move_speed = 200.0
@export var lifetime_seconds = 1.0

var spawn_time
var lifetime = 0.0

func _ready() -> void:
	spawn_time = main.seconds()

func _process(delta: float) -> void:
	lifetime += delta
	var alpha = 1.0 - clamp(inverse_lerp(spawn_time, spawn_time + lifetime_seconds, spawn_time + lifetime), 0.0, 1.0)
	modulate = Color(modulate.r, modulate.g, modulate.b, alpha)
	if alpha <= 0.0:
		queue_free()
	



