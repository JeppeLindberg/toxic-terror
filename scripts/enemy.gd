extends Area2D

@onready var enemy_pos_1 = get_node('/root/main/camera_pivot/enemy_pos_1')
@onready var enemy_pos_2 = get_node('/root/main/camera_pivot/enemy_pos_2')
@onready var ui = get_node('/root/main/ui')
@onready var main = get_node('/root/main')
@onready var manager = get_node('/root/main/manager')
@onready var spawn_pos = get_node('/root/main/camera_pivot/enemy_spawn_pos')
@onready var bullets = get_node('/root/main/bullets')

var target_pos_node = null
var initialized = false

@export var tier_1: PackedScene
@export var tier_2: PackedScene
@export var move_speed = 20.0
@export var max_health = 100.0
@export var current_tier = 2
@export var explode: PackedScene

@onready var _current_health = max_health
var damage_taken_dec = 1.0
var current_health_dec = 1.0
var health_dec_visual_modifier = 0.0

signal spawn_complete
signal health_depleted


func _ready() -> void:
	add_to_group('enemy')

	target_pos_node = enemy_pos_1;

	spawn_current_tier()

func _process(delta: float) -> void:
	if not initialized:
		ui.enemy_health.set_health_dec(1.0)
		spawn_complete.emit()
		initialized = true

	current_health_dec = clamp(_current_health/max_health, 0.0, 1.0)
	var health_dec_visual = current_health_dec + health_dec_visual_modifier
	ui.enemy_health.set_health_dec(health_dec_visual)
	health_dec_visual_modifier = move_toward(health_dec_visual_modifier, 0.0, delta)

	if manager.simulate:
		global_position +=( target_pos_node.global_position - global_position).normalized() * move_speed*delta
		if target_pos_node.global_position.distance_to(global_position) < 5.0:
			if target_pos_node == enemy_pos_1:
				target_pos_node = enemy_pos_2
			else:
				target_pos_node = enemy_pos_1
		

	if not manager.simulate:
		var dist =  move_speed*delta * 10.0
		if spawn_pos.global_position.distance_to(global_position) < dist:
			global_position = spawn_pos.global_position
		else:
			global_position +=( spawn_pos.global_position - global_position).normalized() *dist

func go_to_next_tier():
	current_tier += 1
	max_health += 50
	health_dec_visual_modifier = -1.0
	_current_health = max_health

	spawn_current_tier()

func spawn_current_tier():
	for bullet in bullets.get_children():
		if bullet.remove_when_sceen_cleared:
			bullet.queue_free()

	for child in main.get_children_in_group(self, 'tier'):
		child.queue_free()

	var new_tier = null
	if current_tier == 1:
		new_tier = tier_1.instantiate()
	if current_tier == 2:
		new_tier = tier_2.instantiate()
	add_child(new_tier)
	new_tier.position = Vector2.ZERO

	for child in main.get_children_in_group(new_tier, 'behaviour'):
		if child.activate_at_dec == 1.0:
			child.activate()
			return;


func hit(damage = 1.0):
	var prev_dec = _current_health/max_health
	_current_health -= damage * damage_taken_dec
	current_health_dec = clamp(_current_health/max_health, 0.0, 1.0)

	for child in main.get_children_in_group(self, 'behaviour'):
		if current_health_dec <= child.activate_at_dec and child.activate_at_dec < prev_dec:
			child.activate()
			break;
	
	if _current_health <= 0.0:
		health_depleted.emit()

func destroy():
	var new_explode = explode.instantiate()
	main.add_child(new_explode)
	new_explode.global_position = global_position
	queue_free()
