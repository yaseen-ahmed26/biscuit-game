extends Node

var http_request: HTTPRequest = HTTPRequest.new()

var url

func _ready() -> void:
	url = GameManager.read_json("res://secrets.json").saves_url
	add_child(http_request)

func get_saved_data(save_id: String):
	var error = http_request.request("%s/%s" % [url ,save_id])
	
	if error != OK:
		print("An error occurred")
		return GameManager.read_json("res://data/default_stats.json")

	var response = await http_request.request_completed
	
	var result = response[0]
	var response_code = response[1]
	var body = response[3]

	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.parse_string(body.get_string_from_utf8())
		return json
	else:
		print("Failed to get data ", response_code)
		return GameManager.read_json("res://data/default_stats.json")

func send_put_request(save_id, data_to_save: Dictionary):		
	var json_query = JSON.stringify(data_to_save)
	var headers = ["Content-Type: application/json"]
		
	var error = http_request.request("%s/%s" % [url, save_id], headers, HTTPClient.METHOD_PUT, json_query)
	
	if error != OK:
		print("An error occurred while starting the HTTP PUT request.")
		return false
		
	var response = await http_request.request_completed
	
	var result = response[0]
	var response_code = response[1]
	var body = response[3]
	
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.parse_string(body.get_string_from_utf8())
		return true
	else:
		print("Failed to update data. Response code: ", response_code)
	
	return false
