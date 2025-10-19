extends Panel

@onready var manager = get_node('/root/main/manager')


func _process(delta: float) -> void:
		
	if manager.fade_out:
		var prev_color = modulate
		var calc_a = clamp(prev_color.a + delta, 0, 1)
		var new_color = Color(prev_color.r, prev_color.g, prev_color.b, calc_a)
		modulate = new_color
