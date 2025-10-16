extends Sprite2D

var target_radius_px = 100.0
@export var size_x_px = 2000.0


func _process(_delta: float) -> void:
	scale = Vector2.ONE * 2.0/size_x_px * target_radius_px

