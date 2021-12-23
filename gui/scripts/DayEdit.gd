extends "res://scripts/Day.gd"



func _ready():
	var templates = ServerCommunicator.get_day_templates()
	for template in templates:
		$DayTemplate.add_item(template)


