extends Node2D

@export var emitters: Array[Node2D]


func _process(_delta: float) -> void:
	for emitter in emitters:
		if emitter.no_emitted == 0:
			return
	
	queue_free()
