extends Node



# Idk how to call ts so i just take the name from the minecraft plugin (aka placeholderapi goated plugin btw)


func read(info : String, target : Node, source : Node) -> float:
	var placeholder_regex := RegEx.new()
	#ts really cool ^ (i js learnt abt it)
	var regex_error := placeholder_regex.compile("%([A-Za-z_][A-Za-z0-9_]*)%")
	# ^ basically it finds contiguous subsequence of characters (academic words ahhh) 
	# that belongs in % % (group 0), while the characters in parentheses are the group 1 
	# (the actual placeholder name), the A-Z thing represents the, you know, ASCII shit.
	if regex_error != OK:
		push_error("PlaceholderAPI: failed to compile placeholder pattern.")
		return NAN

	var expression_text := info
	var input_names := PackedStringArray()
	var input_values: Array = []
	var placeholder_inputs := {}

	for placeholder_match in placeholder_regex.search_all(info):
		var placeholder: String = placeholder_match.get_string(1) 
		# ^ get string 1 to get group 1 (aka the placeholder name, which is inside the parentheses)
		var input_name: String
		if placeholder_inputs.has(placeholder):
			input_name = placeholder_inputs[placeholder]
		else:
			var placeholder_result := _read_numeric_placeholder(placeholder, target, source)
			if not placeholder_result.found:
				return NAN

			input_name = "placeholder_%d" % input_names.size()
			placeholder_inputs[placeholder] = input_name
			input_names.append(input_name)
			input_values.append(placeholder_result.value)

		expression_text = expression_text.replace(placeholder_match.get_string(), input_name)

	var expression := Expression.new()
	var parse_error := expression.parse(expression_text, input_names)
	if parse_error != OK:
		push_error("PlaceholderAPI: invalid equation '%s': %s" % [info, expression.get_error_text()])
		return NAN

	var result: Variant = expression.execute(input_values, null, false)
	if expression.has_execute_failed():
		push_error("PlaceholderAPI: failed to evaluate equation '%s'." % info)
		return NAN
	if typeof(result) != TYPE_INT and typeof(result) != TYPE_FLOAT:
		push_error("PlaceholderAPI: equation '%s' did not evaluate to a number." % info)
		return NAN

	return float(result)


func _read_numeric_placeholder(placeholder: String, target: Node, source: Node) -> Dictionary:
	var value: Variant
	var enemy_property_name := ""
	match placeholder:
		"towerdamage":
			if not source is Tower:
				push_error("PlaceholderAPI: '%towerdamage%' requires a tower as the source.")
				return {"found": false}

			var tower := source as Tower
			var setup_node_name: String
			if tower.Stats is SingleTarget:
				setup_node_name = "SingleTarget"
			elif tower.Stats is AreaOfEffect:
				setup_node_name = "AreaOfEffect"
			elif tower.Stats is Duelist:
				setup_node_name = "Duelist"
			else:
				push_error("PlaceholderAPI: cannot determine the tower type for '%towerdamage%'.")
				return {"found": false}

			var setup_node := tower.get_node_or_null(setup_node_name)
			var damage_property := _get_object_property(setup_node, "Damage")
			if not damage_property.found:
				push_error("PlaceholderAPI: tower node '%s' has no Damage property." % setup_node_name)
				return {"found": false}
			value = damage_property.value
		"distancetotower":
			if not target is Node2D or not source is Node2D:
				push_error("PlaceholderAPI: '%distancetotower%' requires Node2D target and source.")
				return {"found": false}
			var enemy := target as Node2D
			var tower := source as Node2D
			value = enemy.global_position.distance_to(tower.global_position)
		"enemycurrentHP":
			enemy_property_name = "CurrentHP"
		"enemymaxHP":
			enemy_property_name = "MaxHP"
		"enemycurrentspeed":
			enemy_property_name = "Speed"
		"enemycurrentdefense":
			enemy_property_name = "Defense"
		_:
			push_error("PlaceholderAPI: cannot resolve placeholder '%%%s%%'." % placeholder)
			return {"found": false}

	if not enemy_property_name.is_empty():
		var enemy_property := _get_object_property(target, enemy_property_name)
		if not enemy_property.found:
			push_error("PlaceholderAPI: target has no property '%s'." % enemy_property_name)
			return {"found": false}
		value = enemy_property.value

	if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
		push_error("PlaceholderAPI: placeholder '%%%s%%' is not numeric." % placeholder)
		return {"found": false}

	return {"found": true, "value": float(value)}

	#messi but im it works ig


func _get_object_property(object: Object, property_name: String) -> Dictionary:
	if object == null or not is_instance_valid(object):
		return {"found": false}

	for property in object.get_property_list():
		if property.name == property_name:
			return {"found": true, "value": object.get(property_name)}

	return {"found": false}
