extends OptionButton


func _ready():
	var templates = ServerCommunicator.get_week_templates()
	var item_selected = ServerCommunicator.get_template_week(get_parent().get_parent().KW)
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
	
