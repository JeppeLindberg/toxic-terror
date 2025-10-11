extends RichTextLabel


var extra_effects = \
{	
	'<normal>': '@',
	'<wave>': '[custom_wave index=#]@[/custom_wave]'
}

var all_symbols_visible = false

func set_text_raw(raw, symbols = 10000):
	all_symbols_visible = false

	text = _raw_to_bb(raw, symbols)

func _raw_to_bb(raw, symbols = 10000):
	var output = ''
	var raw_index = 0
	var bb_index = 0
	var current_extra_effect = '<normal>'

	while raw_index < len(raw):
		if raw[raw_index] == ' ':
			output += ' '
			raw_index += 1
			symbols += 1

		for effect in extra_effects.keys():
			if raw.substr(raw_index).begins_with(effect):
				raw_index += len(effect)
				current_extra_effect = effect

		if raw_index < len(raw):
			var next_output = raw[raw_index]

			next_output = _add_extra_effect(current_extra_effect, bb_index, next_output)

			if bb_index > symbols:
				next_output = '[color=#FFFFFF00]' + next_output
			else:			
				next_output = '[color=#FFFFFFFF]' + next_output
		
			output += next_output

		raw_index += 1
		bb_index += 1
	
	var bb_length = bb_index
		
	if symbols >= bb_length:
		all_symbols_visible = true
	
	return output

func _add_extra_effect(tag, index, tex):
	return extra_effects[tag].replace('#', str(index)).replace('@', tex)
