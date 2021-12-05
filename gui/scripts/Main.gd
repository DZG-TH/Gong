extends ScrollContainer
var week = preload("res://scenes/Week.tscn")
var panel_container = preload("res://scenes/PanelContainer.tscn")

func _ready():
	print("waiting for connection")
	while !ServerCommunicator.connected:
		yield(get_tree().create_timer(1.0),"timeout")
	print("connected")
	var current_week = ServerCommunicator.get_current_week()
	for _i in range(0, 53):
		var kw = week.instance()
		kw.KW = current_week
		kw.name = String(current_week)
		current_week += 1
		if (current_week == 54):
			current_week = 1
		$VBoxContainer.add_child(kw)
	current_week = ServerCommunicator.get_current_week()
	var current_week_node = $VBoxContainer.get_node(String(current_week))
	$VBoxContainer.remove_child(current_week_node)
	var container = panel_container.instance()
	container.name = current_week_node.name
	container.add_child(current_week_node)
	$VBoxContainer.add_child(container)
	$VBoxContainer.move_child(container, 0)
