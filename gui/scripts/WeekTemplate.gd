extends OptionButton

func _ready():
	var templates = ServerCommunicator.get_week_templates()
	var parent_parent = get_parent().get_parent()
	if !parent_parent.name.is_valid_integer():
		parent_parent = parent_parent.get_parent()
	var item_selected = ServerCommunicator.get_template_week(int(parent_parent.KW))
	var found = false
	var counter = 0
	for template in templates:
		add_item(template, counter)
		counter += 1
		if template == item_selected:
			select(get_item_index(counter - 1))
			found = true
	# cant happen but i will leave it in anyways
	if !found:
		add_item("Custom", counter + 2)
		select(get_item_index(counter + 2))
	

func _item_selected(index: int):
	ServerCommunicator.set_template_week(get_parent().get_parent().KW, get_item_text(index))
	var parent_parent = get_parent().get_parent()
	var mainbar = get_parent().get_parent().get_node("MainBar")
	for child in mainbar.get_children():
		if child.get_script() == null:
			child = child.get_child(0)
		var selector = child.get_node("DayTemplate")
		print("selector:", selector)
		var template = ServerCommunicator.get_template_week_day(int(parent_parent.KW), int(child.num_day_of_week))
		print("template", template)
		if template == "Custom":
			selector.add_item(template, -1)
			select(get_item_index(-1))
		for i in selector.get_item_count():
			if selector.get_item_text(i) == template:
				selector.select(i)
				break

