extends AnimatableBody2D

@export var move_speed = 10.0

@onready var manager = get_node('/root/main/manager')





func _physics_process(delta: float) -> void:
	if manager.simulate:
		global_position += Vector2.DOWN * move_speed * delta
