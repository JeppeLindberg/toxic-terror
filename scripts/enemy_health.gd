extends MarginContainer

@onready var red = get_node('red')
@onready var green = get_node('red/green')

var max_health_pix = 100.0


func _ready() -> void:
	max_health_pix = red.size.x
	green.size.x = max_health_pix

func set_health_dec(decimal):
	green.size.x = clamp(decimal, 0.0, 1.0) * max_health_pix
