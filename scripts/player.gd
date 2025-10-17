extends RigidBody2D

var movement_direction: Vector2

@export var sit_prefab: PackedScene
@export var good_boy_prefab: PackedScene
@export var movement_speed : float = 200.0
@export var slow_mode_mult = 0.25

@onready var main = get_node('/root/main')
@onready var dog = get_node('/root/main/dog')
@onready var behaviour_wide = get_node('behaviour_wide')
@onready var behaviour_narrow = get_node('behaviour_narrow')
@onready var sprite:Sprite2D = get_node('sprite')
@onready var all_shield = get_node('all_shield')
@onready var damage_taken_timer:Timer = get_node('damage_taken_timer')
@onready var manager = get_node('/root/main/manager')
@onready var spawn_pos = get_node('/root/main/camera_pivot/player_spawn_pos')

var accept_input = true

var starting_pos
var improve_accuracy = false


func _ready() -> void:
	add_to_group('player')

	global_position = spawn_pos.global_position
	starting_pos = global_position

func reset():
	global_position = starting_pos

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('sit'):
		var new_text = null
		if dog.state != 'sit':
			new_text = sit_prefab.instantiate()
		else:
			new_text = good_boy_prefab.instantiate()
		main.add_child(new_text)
		new_text.global_position = global_position
		dog.sit()
	
	if Input.is_action_pressed('improve_accuracy'):
		if improve_accuracy == false:
			behaviour_narrow.activate()
		improve_accuracy = true
	else:
		if improve_accuracy == true:
			behaviour_wide.activate()
		improve_accuracy = false


func _physics_process(_delta):
	handle_movement_controls()

	# if manager.simulate:
	var modified_speed = movement_speed
	if improve_accuracy:
		modified_speed *= slow_mode_mult

	linear_velocity = movement_direction * modified_speed
	
	# if not manager.simulate:
	# 	var dist =  movement_speed * 10.0
	# 	if spawn_pos.global_position.distance_to(global_position) < dist:
	# 		linear_velocity = spawn_pos.global_position - global_position
	# 	else:
	# 		linear_velocity =( spawn_pos.global_position - global_position).normalized() * dist

	
func handle_movement_controls():
	if not accept_input:
		movement_direction = Vector2.ZERO
		return
		
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	movement_direction = input.normalized()

func hit():
	all_shield.enabled = true
	damage_taken_timer.start()


func _on_damage_taken_timer_timeout() -> void:
	all_shield.enabled = false
	print(all_shield.enabled)
