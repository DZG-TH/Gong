extends Node


var week_templates = ["Testwoche", "Normale Woche"]
var day_templates = ["Testtag", "Normal"]
var current_week = 50
var current_day_of_week = 3

var udp := PacketPeerUDP.new()
const SERVER_ADDRESS = "192.168.178.0"
const SERVER_PORT = 4242
signal connected()



enum DAY{
	MONDAY,
	TUESDAY,
	WEDNESDAY,
	THURSTDAY,
	FRIDAY,
	SATURDAY,
	SUNDAY
}

func _ready():
	udp.connect_to_host(SERVER_ADDRESS, SERVER_PORT) #WICHTIG UDP PORT
	
	get_current_day_of_week()
	get_current_week()
	get_day_templates()
	get_week_templates()
	emit_signal("connected")

func get_week_templates():
	if week_templates == null:
		get_week_templates_req()
	return week_templates

func get_day_templates():
	if day_templates == null:
		get_day_templates_req()
	return day_templates

func get_current_week():
	if current_week == null:
		get_current_week_req()
	return current_week
	
func get_current_day_of_week():
	if current_week == null:
		get_current_day_of_week_req()
	return current_day_of_week

func get_template_week_day(kw: int, day: int ):
	return "Normal"

func get_template_week(kw: int):
	#returns the template of the week 
	#returns "custom" if cant be matched
	return "Normal"

#the following methods return true if it worked serverside

func set_template_day(kw: int, day: int) -> bool:
	make_request("SET TEMPLATE DAY % %" % [kw, day])
	return true

func set_template_week(kw: int) -> bool:
	make_request("SET TEMPLATE WEEK %" % kw)
	return true
 
# may be added in the future
func add_template_week(name: String, times: Array) -> bool: 
	#Array stores the day templates 
	return true

# may be added in the future
func add_template_day(name: String, times: Array) -> bool: 
	return true

func make_request(content: String):
	udp.put_packet(content.to_utf8())
	while udp.get_available_packet_count() == 0:
		yield(get_tree().create_timer(0.5),"timeout")
		print("waiting for packet")
	var packet_content = udp.get_packet().get_string_from_utf8()
	
func get_week_templates_req():
	make_request("GET TEMPLATES WEEK")
	

func get_day_templates_req():
	make_request("GET TEMPLATES DAY")

func get_current_week_req():
	make_request("GET WEEK CURRENT")

func get_current_day_of_week_req():
	make_request("GET DAY_OF_WEEK CURRENT")

