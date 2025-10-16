extends Area2D


var max_size
@export var enabled = false

@export var seconds_to_grow_to_max = 1.0

@onready var shield_collider = get_node('shield_collider')
@onready var sprite = get_node('sprite')


func _ready() -> void:
	max_size = shield_collider.shape.radius
	shield_collider.shape.radius = 0


func _process(delta: float) -> void:
	if enabled and shield_collider.shape.radius != max_size:
		visible = true
		shield_collider.shape.radius += (1.0/seconds_to_grow_to_max) * max_size * delta
		if shield_collider.shape.radius > max_size:
			shield_collider.shape.radius = max_size
	
	if not enabled and shield_collider.shape.radius != 0:
		if shield_collider.shape.radius - (1.0/seconds_to_grow_to_max) * max_size * delta < 0:
			shield_collider.shape.radius = 0
		else:
			shield_collider.shape.radius -= (1.0/seconds_to_grow_to_max) * max_size * delta
	
	shield_collider.disabled = shield_collider.shape.radius == 0
	sprite.target_radius_px = shield_collider.shape.radius
	sprite.visible = shield_collider.shape.radius != 0




func hit():
	pass
