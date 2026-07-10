extends Node

var time_played: float = 0.0

func _process(delta: float) -> void:
	time_played += delta
	
func get_formatted_time() -> String:
	var total_secs: int = int(time_played)
	var hours: int = total_secs / 3600
	var minutes: int = (total_secs % 3600) / 60
	var seconds: int = total_secs % 60
	
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

func get_time_played():
	return time_played

func read_json(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var json = JSON.new()
		
		if json.parse(file.get_as_text()) == OK:
			return json.get_data()
