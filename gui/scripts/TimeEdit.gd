extends HBoxContainer

signal remove(node)

func _on_Remove_pressed():
	emit_signal("remove", self)

func from_times(hour: int, minute: int):
	$Hour.value = hour
	$Minute.value = minute
