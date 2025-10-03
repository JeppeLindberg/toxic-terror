extends RigidBody2D

var movement_direction: Vector2

@export var movement_speed : float = 200.0

@onready var main = get_node('/root/main')
@onready var sprite:Sprite2D = get_node('sprite')
@onready var accept_input = true

var starting_pos


func _ready() -> void:
	add_to_group('player')

	starting_pos = global_position

func reset():
	global_position = starting_pos

func _physics_process(delta):
	handle_controls(delta)

	linear_velocity = movement_direction * movement_speed

	
func handle_controls(_delta):
	if not accept_input:
		movement_direction = Vector2.ZERO

		if Input.is_action_just_pressed('reset'):
			main.reset();

		return
		
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	movement_direction = input.normalized()

func hit():
	print('player_hit')
