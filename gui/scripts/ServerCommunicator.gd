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
 
# may be added in the future
func add_template_week(name: String, times: Array) -> bool: 
	return bool(make_request("ADD TEMPLATE WEEK %s,%s"% [name, times]))

# may be added in the future
func add_template_day(name: String, times: Array) -> bool: 
	return bool(make_request("ADD TEMPLATE DAY %s,%s"%[name, times]))

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
	
func get_week_templates_req():
	week_templates = make_request("GET TEMPLATES WEEK").split(",")
	

func get_day_templates_req():
	day_templates = make_request("GET TEMPLATES DAY").split(",")

func get_current_week_req():
	current_week = int(make_request("GET WEEK CURRENT"))

func get_current_day_of_week_req():
	current_day_of_week = int(make_request("GET DAY_OF_WEEK CURRENT"))

func play_gong():
	return bool(make_request("PLAY GONG"))

