extends VBoxContainer

var day_scene = preload("res://scenes/Day.tscn")
var panel_container = preload("res://scenes/PanelContainer.tscn")
var KW = 0

func _ready():
	for _i in range(5):
		$MainBar.add_child(day_scene.instance())
	$MainBar.get_child(0).day_of_week = "Montag"
	$MainBar.get_child(0).num_day_of_week = 1
	$MainBar.get_child(1).day_of_week = "Dienstag"
	$MainBar.get_child(1).num_day_of_week = 2
	$MainBar.get_child(2).day_of_week = "Mittwoch"
	$MainBar.get_child(2).num_day_of_week = 3
	$MainBar.get_child(3).day_of_week = "Donnerstag"
	$MainBar.get_child(3).num_day_of_week = 4
	$MainBar.get_child(4).day_of_week = "Freitag"
	$MainBar.get_child(4).num_day_of_week = 5
	for i in $MainBar.get_children():
		i.name = i.day_of_week
	$TopBar/KW.text = String(KW)
	if int(name) == ServerCommunicator.get_current_week():
		var day_of_week = ServerCommunicator.get_current_day_of_week()
		if day_of_week == 6 or day_of_week == 7:
			return
		var current_day_node = $MainBar.get_child(-1)
		var old_postion = current_day_node.get_index()
		$MainBar.remove_child(current_day_node)
		var container = panel_container.instance()
		container.name = current_day_node.name
		container.add_child(current_day_node)
		$MainBar.add_child(container)
		$MainBar.move_child(container, old_postion)

