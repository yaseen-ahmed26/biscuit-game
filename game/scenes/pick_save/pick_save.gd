extends Node

@onready var hbox_container: HBoxContainer = $background/HBoxContainer
@onready var continue_btn: Button = $background/continue_btn

# UI
var type_selected: String

# Websocket
const COUNTRIES: Dictionary[String, String] = {
	"GB": "United Kingdom"
}
const SECRETS_PATH: String = "res://secrets.json"

var client: HTTPClient = HTTPClient.new()
var socket: WebSocketPeer = WebSocketPeer.new()

var websocket_url: String = ""

var connected = false

# Local saves
var config = ConfigFile.new()

func _ready() -> void:
	websocket_url = read_json(SECRETS_PATH).websocket_url
	
	for item in hbox_container.get_children():
		if not item is Button: continue
		
		item.pressed.connect(_save_selected.bind(item))

func _process(_delta: float) -> void:	
	socket.poll()
	
	var state = socket.get_ready_state()
	
	if state == WebSocketPeer.STATE_OPEN:
		if not connected:
			_on_connected()
			connected = true

		while socket.get_available_packet_count() > 0:
			var packet = socket.get_packet()
			var message = packet.get_string_from_utf8()
			
			_on_message_received(message)
	elif state == WebSocketPeer.STATE_CLOSING:
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		
		print("websocket closed: (%d) %s" % [code, reason])
		set_process(false)

func _start_websocket():
	Signals.change_screen.emit("pick_save", "online_save")
	
	var os_name: String = OS.get_name()
	var country_name: String = _get_user_country()
	
	var websocket_metadata = {
		"os": os_name,
		"country": country_name
	}
	
	var query_string = client.query_string_from_dict(websocket_metadata)
	
	set_process(true)
	
	var error = socket.connect_to_url(websocket_url + "?" + query_string)
	
	if error != OK:
		print("filaed to connect to the websocket: ", error)
		set_process(false)
	
func _start_local_save():
	pass

func _get_user_country() -> String:
	var locale_parts: PackedStringArray = OS.get_locale().split("_")
	var country_code: String = "def"
	
	if locale_parts.size() > 1:
		country_code = locale_parts[1].left(2).to_upper() 
	
	var country_name: String = COUNTRIES.get(country_code, country_code)
	
	return country_name
	
func _on_message_received(message):
	var parsed = JSON.parse_string(message)
	
	if parsed.type == "information":
		Signals.display_code.emit(parsed.login_code)

func _send_message(message: String) -> void:
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		var error = socket.send_text(message)
		
		if error != OK:
			print("error sending message: ", error)

func _on_connected() -> void:	
	# var json_string = JSON.stringify(player_data)
	
	# socket.send_text(json_string)
	pass

func read_json(path: String) -> Variant:
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var json = JSON.new()
		
		if json.parse(file.get_as_text()) == OK:
			return json.get_data()
			
	return null
	
# UI stuff
func _save_selected(item: Button):
	type_selected = item.name
	continue_btn.disabled = false
	continue_btn.text = "Continue with " + type_selected.capitalize()
	
func _on_continue_btn_pressed():
	match type_selected:
		"online": _start_websocket()
		"local": _start_local_save()
