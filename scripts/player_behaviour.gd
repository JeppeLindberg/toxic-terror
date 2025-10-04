extends Node2D



@onready var main = get_node('/root/main')


func _ready() -> void:
	add_to_group('behaviour')


func activate():
	for emitter in main.get_children_in_group(get_parent(), 'bullet_emitter'):
		emitter.emit = false
	for emitter in main.get_children_in_group(self, 'bullet_emitter'):
		emitter.emit = true



