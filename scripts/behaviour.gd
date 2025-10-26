extends Node2D

@export var activate_at_dec = 1.0
@export var damage_taken_dec = 1.0

@onready var main = get_node('/root/main')
@onready var bullets = get_node('/root/main/bullets')


func _ready() -> void:
	add_to_group('behaviour')


func activate():
	for bullet in bullets.get_children():
		if bullet.remove_when_sceen_cleared:
			bullet.queue_free()

	var enemy = self
	while not enemy.is_in_group('enemy'):
		enemy = enemy.get_parent()

	enemy.damage_taken_dec = damage_taken_dec
	for emitter in main.get_children_in_group(get_parent(), 'bullet_emitter'):
		emitter.emit = false
	for emitter in main.get_children_in_group(self, 'bullet_emitter'):
		emitter.emit = true
