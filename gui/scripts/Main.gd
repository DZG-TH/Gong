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
	
	var time_in_seconds = time_to_secs(OS.get_time())
	var seconds_to_next_day = 86400 - time_in_seconds
	print("seconds to next day", seconds_to_next_day)
	get_tree().create_timer(seconds_to_next_day).connect("timeout",ServerCommunicator,"update_current_day_of_week")
	ServerCommunicator.connect("current_week_updated", self, "update_current_week")
	ServerCommunicator.connect("current_day_of_week_updated", self, "update_current_day")

func time_to_secs(time):
	var seconds = time["second"]
	seconds += time["minute"]*60
	seconds += time["hour"]*3600
	return seconds
	
func update_current_day():
	print("update current day")
	for child in $VBoxContainer.get_children():
		child.queue_free()
	yield(get_tree().create_timer(1.0),"timeout")
	_ready()
