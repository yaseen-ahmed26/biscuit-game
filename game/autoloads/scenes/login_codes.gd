extends Node

func _ready() -> void:
	pass

func read_json(path: String) -> Variant:
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var json = JSON.new()
		
		if json.parse(file.get_as_text()) == OK:
			return json.get_data()
			
	return null
