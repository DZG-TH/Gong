extends OptionButton

func _ready():
	var templates = ServerCommunicator.get_day_templates()
	var item_selected = ServerCommunicator.get_template_week_day(int(get_parent().get_parent().name),get_parent().num_day_of_week)
	var found = false
	var counter = 0
	for template in templates:
		add_item(template, counter)
		counter += 1
		if template == item_selected:
			select(get_item_index(counter - 1))
			found = true
	if !found:
		add_item("Custom", counter + 2)
		select(get_item_index(counter + 2))
