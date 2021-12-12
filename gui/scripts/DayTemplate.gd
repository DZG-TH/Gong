extends OptionButton
var kw

func _ready():
	yield(get_tree().create_timer(0.5),"timeout")
	var templates = ServerCommunicator.get_day_templates()
	var parent_parent = get_parent().get_parent().get_parent()
	if !parent_parent.name.is_valid_integer():
		kw = int(parent_parent.get_parent().name)
	else:
		kw = int(parent_parent.name)
	var parent_day = get_parent()
	var day
	if parent_day.get_script() != null: #has script
		day = int(parent_day.num_day_of_week)
	else:
		day = int(parent_day.get_parent().num_day_of_week)
	var item_selected = ServerCommunicator.get_template_week_day(kw, day)
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


func _item_selected(index):
	ServerCommunicator.set_template_day(kw, get_parent().num_day_of_week, get_item_text(index))
	var parent_week = get_parent().get_parent().get_parent()
	if parent_week.get_script() == null:
		parent_week = parent_week.get_parent()
		if parent_week.get_script() == null:
			parent_week = parent_week.get_parent()
	var selector = parent_week.get_node("TopBar/WeekTemplate")
	var template = ServerCommunicator.get_template_week(parent_week.KW)
	print("TEST", template)
	for i in selector.get_item_count():
		if selector.get_item_text(i) == template:
			selector.select(i)
			return
	if template == "Custom":
		selector.add_item(template, -1)
		select(get_item_index(-1))
