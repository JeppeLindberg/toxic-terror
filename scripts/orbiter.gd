extends Node2D

var distance = 100.0
var seconds_per_lap = 8.0

@onready var main = get_node('/root/main')


func _process(_delta: float) -> void:
	position = Vector2.RIGHT * distance * cos((main.seconds() * PI * 2.0) / seconds_per_lap) + \
				Vector2.DOWN * distance * sin((main.seconds() * PI * 2.0) / seconds_per_lap) ;
