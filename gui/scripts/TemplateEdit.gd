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
		print("create week")
		root_control.add_child(editor_week_scene.instance())
		editor_week_node = root_control.get_node("TemplateEditWeek")
		editor_week_node.popup_centered_ratio(0.75)
	
	elif id == ID_DAY:
		print("create day")
		root_control.add_child(editor_day_scene.instance())
		editor_day_node = root_control.get_node("TemplateEditDay")
		editor_day_node.popup_centered_ratio(0.75)

func edit_template(id: int):
	if id == ID_WEEK:
		print("edit template week")
		$HBoxContainer/Edit/Weeks.clear()
		for i in ServerCommunicator.get_week_templates():
			$HBoxContainer/Edit/Weeks.add_item(i)
		$HBoxContainer/Edit/Weeks.connect("id_pressed",self,"id_pressed_week")
		$HBoxContainer/Edit/Weeks.popup_centered()
	elif id == ID_DAY:
		print("edit template day")
		$HBoxContainer/Edit/Days.clear()
		for i in ServerCommunicator.get_day_templates():
			$HBoxContainer/Edit/Days.add_item(i)
		$HBoxContainer/Edit/Days.connect("id_pressed",self,"id_pressed_day")
		$HBoxContainer/Edit/Days.popup_centered()

func id_pressed_week(id: int):
	var index = $HBoxContainer/Edit/Weeks.get_item_index(id)
	var template = $HBoxContainer/Edit/Weeks.get_item_text(index)
	
	root_control.add_child(editor_week_scene.instance())
	editor_week_node = root_control.get_node("TemplateEditWeek")
	editor_week_node.popup_centered_ratio(0.75)
	
	editor_week_node.load_from_templates(ServerCommunicator.get_info_template_week(template), template)
	print(template)

func id_pressed_day(id: int):
	var index = $HBoxContainer/Edit/Days.get_item_index(id)
	var template = $HBoxContainer/Edit/Days.get_item_text(index)
	var times = ServerCommunicator.get_info_template_day(template)
	
	root_control.add_child(editor_day_scene.instance())
	editor_day_node = root_control.get_node("TemplateEditDay")
	editor_day_node.popup_centered_ratio(0.75)
	
	editor_day_node.load_from_times(times, template)
	print(template)
