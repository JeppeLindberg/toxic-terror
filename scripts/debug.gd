extends Control



func add_draw_line(from, to):
	pass
	# lines.append([from, to])
	# queue_redraw()

var lines = []


func _draw():
	for line in lines:
		var world_to_screen_pos = get_viewport().get_canvas_transform()
		draw_line( world_to_screen_pos*line[0], world_to_screen_pos*line[1], Color.DARK_RED)
	lines = []
