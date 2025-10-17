extends Node2D


var added_movement = Vector2.ZERO

@onready var main = get_node('/root/main')

@export var speed = 100.0


func _process(_delta: float) -> void:
	added_movement = Vector2.DOWN * cos(main.seconds() * PI * 2) * speed
