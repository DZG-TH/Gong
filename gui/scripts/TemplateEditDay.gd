extends WindowDialog

var time_edit = preload("res://scenes/TimeEdit.tscn")
var time_count = 0

func load_from_times(arr: Array, name_ : String):
	var counter = 0
	for i in arr:
		var hour_minute = i.split(".")
		_on_Add_pressed()
		$VBoxContainer/TimesContainer/VBoxContainer.get_node(String(counter)).from_times(int(hour_minute[0]),int(hour_minute[1]))
		counter += 1
	$VBoxContainer/Name.text = name_


func _on_Add_pressed():
	var time_edit_instance = time_edit.instance()
	$VBoxContainer/TimesContainer/VBoxContainer.add_child(time_edit_instance)
	time_edit_instance.connect("remove",self, "remove_time_edit")
	time_edit_instance.name = String(time_count)
	time_count += 1

func remove_time_edit(node):
	node.queue_free()


func _on_save_pressed():
	var arr = []
	for time in $VBoxContainer/TimesContainer/VBoxContainer.get_children():
		var hour = String(time.get_node("Hour").value)
		var minute = String(time.get_node("Minute").value)
		arr.append(hour+"."+minute)
	var worked = ServerCommunicator.add_template_day(get_template_name(), arr)
	print("saved:", worked)
	yield(get_tree().create_timer(1.0), "timeout")
	ServerCommunicator.update_day_templates()


func _on_popup_hide():
	queue_free()

func get_template_name() -> String:
	return $VBoxContainer/Name.text
