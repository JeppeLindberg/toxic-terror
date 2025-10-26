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
@onready var player_fade_out_pos = get_node('/root/main/camera_pivot/player_fade_out_pos')
@export var no_of_times_hit: RichTextLabel

var accept_input = true

var starting_pos
var improve_accuracy = false


func _ready() -> void:
	add_to_group('player')

	global_position = spawn_pos.global_position
	starting_pos = global_position

	behaviour_wide.activate()

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


func _physics_process(delta):
	handle_movement_controls()

	if not manager.game_ending:
		var modified_speed = movement_speed
		if improve_accuracy:
			modified_speed *= slow_mode_mult

		linear_velocity = movement_direction * modified_speed
	
	if manager.game_ending:
		var dist =  movement_speed * delta
		var target_node = spawn_pos
		if manager.fade_out:
			target_node = player_fade_out_pos
		if target_node.global_position.distance_to(global_position) < dist:
			global_position = target_node.global_position
		else:
			global_position +=( target_node.global_position - global_position).normalized() *dist

	
func handle_movement_controls():
	if not accept_input:
		movement_direction = Vector2.ZERO
		return
		
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	movement_direction = input.normalized()

func hit():
	if not manager.game_ending:
		no_of_times_hit.text = str(int(no_of_times_hit.text) + 1)
		all_shield.enabled = true
		damage_taken_timer.start()


func _on_damage_taken_timer_timeout() -> void:
	all_shield.enabled = false
