extends Node


var week_templates = null
var day_templates = null
var current_week = null
var current_day_of_week = null

var udp_send := PacketPeerUDP.new()
var udp_recv := PacketPeerUDP.new()
const SERVER_ADDRESS = "127.0.0.1"
const SERVER_PORT = 4242
const CLIENT_PORT = 4241
var connected = false

signal week_templates_updated()
signal day_templates_updated()

func _ready():
	udp_send.connect_to_host(SERVER_ADDRESS, SERVER_PORT)
	udp_recv.listen(CLIENT_PORT,"127.0.0.1")
	get_current_day_of_week()
	get_current_week()
	get_day_templates()
	get_week_templates()
	connected = true

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
	return make_request("GET TEMPLATE WEEK DAY %s,%s"%[kw, day])

func get_template_week(kw: int):
	return make_request("GET TEMPLATE WEEK %s"% kw)

#the following methods return true if it worked serverside

func set_template_day(kw: int, day: int, template: String) -> bool:
	return bool(make_request("SET TEMPLATE DAY %s,%s,%s" % [kw, day, template]))

func set_template_week(kw: int, template: String) -> bool:
	return bool(make_request("SET TEMPLATE WEEK %s,%s" % [kw, template]))
 
func add_template_day(name: String, times: Array) -> bool: 
	var lines = array_to_lines(times)
	day_templates = null
	return bool(make_request("SET CHANGE TEMPLATE DAY %s,%s" % [name, lines]))

func add_template_week(name: String, day_templates: Array) -> bool:
	var lines = array_to_lines(day_templates)
	week_templates = null
	return bool(make_request("SET CHANGE TEMPLATE WEEK %s,%s" % [name, lines]))

func remove_template_day(name: String) -> bool:
	return add_template_day(name, [])

func remove_template_week(name: String) -> bool:
	return add_template_week(name, [])

func get_info_template_day(name: String) -> Array:
	var answer = make_request("GET INFO TEMPLATE DAY %s"%name)
	day_templates = null
	return answer.split(",")

func get_info_template_week(name: String) -> Array:
	var answer = make_request("GET INFO TEMPLATE WEEK  %s"%name)
	week_templates = null
	return answer.split(",")

func make_request(content: String):
	print("put packet " + content)
	udp_send.put_packet(content.to_utf8())
	while udp_recv.get_available_packet_count() == 0:
		pass
	var packet
	while true:
		packet = udp_recv.get_packet().get_string_from_utf8()
		print("recieved" + packet)
		if packet.split("|")[0] == content:
			break
	return packet.split("|")[1]

func get_day_templates_req():
	day_templates = make_request("GET TEMPLATES DAY").split(",")

func get_week_templates_req():
	week_templates = make_request("GET TEMPLATES WEEK").split(",")

func get_current_day_of_week_req():
	current_day_of_week = int(make_request("GET DAY_OF_WEEK CURRENT"))

func get_current_week_req():
	current_week = int(make_request("GET WEEK CURRENT"))

func play_gong():
	return bool(make_request("PLAY GONG"))

func array_to_lines(arr: Array) -> String:
	var lines := ""
	for line in arr:
		lines += "\n" + line
	return lines

func update_week_templates():
	var old_templates = week_templates
	week_templates = null
	yield(get_tree().create_timer(1.0), "timeout")
	if old_templates != get_week_templates():
		emit_signal("week_templates_updated")

func update_day_templates():
	var old_templates = day_templates
	day_templates = null
	yield(get_tree().create_timer(1.0), "timeout")
	if old_templates != get_day_templates():
		emit_signal("day_templates_updated")
