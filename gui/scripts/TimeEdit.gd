extends HBoxContainer

signal remove(node)

func _on_Remove_pressed():
	emit_signal("remove", self)
