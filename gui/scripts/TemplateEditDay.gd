extends WindowDialog

var time_edit = preload("res://scenes/TimeEdit.tscn")




func _on_Add_pressed():
	var time_edit_instance = time_edit.instance()
	$VBoxContainer/TimesContainer.add_child(time_edit_instance)
	time_edit_instance.connect("remove",self, "remove_time_edit")

func remove_time_edit(node):
	node.queue_free()


func _on_save_pressed():
	var arr = []
	for time in $VBoxContainer/TimesContainer.get_children():
		var hour = String(time.get_node("Hour").value)
		var minute = String(time.get_node("Minute").value)
		arr.append(hour+"."+minute)
	var worked = ServerCommunicator.add_template_day($VBoxContainer/Name.text, arr)
	print("saved:", worked)


func _on_popup_hide():
	queue_free()
