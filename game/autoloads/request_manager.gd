extends Node

var url: String = ""

func _ready() -> void:
	url = GameManager.read_json("res://secrets.json").saves_url

func send_request(save_id: String, method: HTTPClient.Method, data: String = "", headers: Array = []) -> Array:
	if save_id.is_empty() or save_id == null: return [false]
	
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)

	var error: Error

	if method == HTTPClient.METHOD_GET:
		error = http_request.request("%s/%s" % [url, save_id])
	else:
		error = http_request.request("%s/%s" % [url, save_id], headers, method, data)

	if error != OK:
		print("An error occurred making the HTTP request")
		http_request.queue_free()
		return [false]
	
	var response = await http_request.request_completed
	
	var result = response[0]
	var response_code = response[1]
	var body = response[3]	
	
	http_request.queue_free()
	
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.parse_string(body.get_string_from_utf8())
		return [true, json]
	else:
		push_warning("Failed to make %s request, response code: %d" % [method, response_code])
		return [false]
