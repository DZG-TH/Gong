extends PanelContainer

var editor_day_scene = preload("res://scenes/TemplateEditDay.tscn")
var editor_week_scene = preload("res://scenes/TemplateEditWeek.tscn")
var editor_day_node
var editor_week_node
var root_control

const ID_WEEK = 0
const ID_DAY = 1


func _ready():
	$HBoxContainer/Create/Button.get_popup().connect("id_pressed",self,"create_template")
	$HBoxContainer/Edit/Button.get_popup().connect("id_pressed",self,"edit_template")
	root_control = get_parent().get_parent()


func create_template(id: int):
	if id == ID_WEEK:
		root_control.add_child(editor_week_scene.instance())
		editor_week_node = root_control.get_node("TemplateEditWeek")
		editor_week_node.popup_centered_ratio(0.75)
	
	elif id == ID_DAY:
		print("create day")
		root_control.add_child(editor_day_scene.instance())
		editor_day_node = root_control.get_node("TemplateEditDay")
		print(editor_day_node)
		editor_day_node.popup_centered_ratio(0.75)
		print(editor_day_node)

func edit_template(id: int):
	if id == ID_WEEK:
		emit_signal("eidt_template_week")
	elif id == ID_DAY:
		emit_signal("edit_template_week")
