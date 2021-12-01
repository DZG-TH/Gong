extends VBoxContainer



var day_of_week := ""
var num_day_of_week := 0



func _process(_delta):
	$DayName.text = day_of_week
