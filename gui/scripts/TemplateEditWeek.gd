extends WindowDialog

var day_scene = preload("res://scenes/DayEdit.tscn")


func _ready():
	for i in range(5):
		var day = day_scene.instance()
		$VBoxContainer/HBoxContainer.add_child(day)
		day.num_day_of_week = i+1
		day.name = String(i+1)
	$VBoxContainer/HBoxContainer.get_child(0).day_of_week = "Montag"
	$VBoxContainer/HBoxContainer.get_child(1).day_of_week = "Dienstag"
	$VBoxContainer/HBoxContainer.get_child(2).day_of_week = "Mittwoch"
	$VBoxContainer/HBoxContainer.get_child(3).day_of_week = "Donnerstag"
	$VBoxContainer/HBoxContainer.get_child(4).day_of_week = "Freitag"

func load_from_templates(arr: Array, _name: String):
	var counter = 1
	for i in arr:
		var day = $VBoxContainer/HBoxContainer.get_node_or_null(String(counter))
		if day == null:
			continue
		day = day.get_node("DayTemplate")
		for ii in range(day.get_item_count()):
			if day.get_item_text(ii) == i:
				day.select(ii)
		counter += 1
	$VBoxContainer/Name.text = _name

func _on_save_pressed():
	var arr := []
	for day in $VBoxContainer/HBoxContainer.get_children():
		var template_selector = day.get_node("DayTemplate")
		arr.append(template_selector.get_item_text(template_selector.selected))
	ServerCommunicator.add_template_week($VBoxContainer/Name.text, arr)

func _on_popup_hide():
	queue_free()
