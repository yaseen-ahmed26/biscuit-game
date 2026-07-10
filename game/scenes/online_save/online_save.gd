extends Control

@onready var link_success: Panel = $link_success
@onready var welcome: RichTextLabel = $link_success/welcome

const COUNTRIES: Dictionary[String, String] = {
	"GB": "United Kingdom"
}
const SECRETS_PATH: String = "res://secrets.json"

var client: HTTPClient = HTTPClient.new()
var socket: WebSocketPeer = WebSocketPeer.new()

var websocket_url: String = ""

var connected = false

func _ready() -> void:
	set_process(false)
	websocket_url = GameManager.read_json(SECRETS_PATH).websocket_url

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

func start_websocket():
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
		print("failed to connect to the websocket: ", error)
		set_process(false)

func _get_user_country() -> String:
	var locale_parts: PackedStringArray = OS.get_locale().split("_")
	var country_code: String = "def"
	
	if locale_parts.size() > 1:
		country_code = locale_parts[1].left(2).to_upper() 
	
	var country_name: String = COUNTRIES.get(country_code, country_code)
	
	return country_name

func _account_link_success(username: String):
	welcome.text = "[color=green]Account Linked: Hello, %s!" % username
	
	var tween_in: Tween = create_tween()
	tween_in.tween_property(link_success, "modulate:a", 1.0, 0.7)
	
	await get_tree().create_timer(4.0).timeout
		
	Signals.change_screen.emit("game")
	
func _on_message_received(message):
	var parsed = JSON.parse_string(message)
	
	if parsed.type == "information":
		$code.text = "[color=green]%s" % parsed.login_code
	elif parsed.type == "user_data":
		SaveManager.store_online_data(parsed)
		
		_account_link_success(parsed.username)

func _send_message(message: String) -> void:
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		var error = socket.send_text(message)
		
		if error != OK:
			print("error sending message: ", error)

func _on_connected() -> void:	
	# var json_string = JSON.stringify(player_data)
	
	# socket.send_text(json_string)
	print("websocket connected")
	pass

func check_save():
	pass
