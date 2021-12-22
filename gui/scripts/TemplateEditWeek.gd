extends WindowDialog

var day_scene = preload("res://scenes/DayEdit.tscn")


func _ready():
	for _i in range(5):
		$VBoxContainer/HBoxContainer.add_child(day_scene.instance())
	$VBoxContainer/HBoxContainer.get_child(0).day_of_week = "Montag"
	$VBoxContainer/HBoxContainer.get_child(0).num_day_of_week = 1
	$VBoxContainer/HBoxContainer.get_child(1).day_of_week = "Dienstag"
	$VBoxContainer/HBoxContainer.get_child(1).num_day_of_week = 2
	$VBoxContainer/HBoxContainer.get_child(2).day_of_week = "Mittwoch"
	$VBoxContainer/HBoxContainer.get_child(2).num_day_of_week = 3
	$VBoxContainer/HBoxContainer.get_child(3).day_of_week = "Donnerstag"
	$VBoxContainer/HBoxContainer.get_child(3).num_day_of_week = 4
	$VBoxContainer/HBoxContainer.get_child(4).day_of_week = "Freitag"
	$VBoxContainer/HBoxContainer.get_child(4).num_day_of_week = 5



func _on_save_pressed():
	var arr := []
	for day in $VBoxContainer/HBoxContainer.get_children():
		var template_selector = day.get_node("DayTemplate")
		arr.append(template_selector.get_item_text(template_selector.selected))
	ServerCommunicator.add_template_week($VBoxContainer/Name.text, arr)

func _on_popup_hide():
	queue_free()
