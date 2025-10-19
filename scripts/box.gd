extends CollisionShape2D

@onready var manager = get_node('/root/main/manager')


func _process(_delta: float) -> void:
	if manager.game_ending:
		queue_free()

