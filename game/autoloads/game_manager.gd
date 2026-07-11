extends Node

var autosave_timer: Timer = Timer.new()

var time_played: float = 0.0

func _ready() -> void:
	add_child(autosave_timer)
	
	autosave_timer.one_shot = false
	autosave_timer.wait_time = 30.0
	
	set_process(false)
	Signals.data_loaded.connect(_on_data_loaded)
	
	autosave_timer.timeout.connect(_on_autosave_timer_timeout)

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

func _on_data_loaded(data: Dictionary):
	if data.get("total_playtime"):
		time_played = data.total_playtime
		
	set_process(true)
	autosave_timer.start()

func _on_autosave_timer_timeout():
	SaveManager.save_game()

func read_json(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var json = JSON.new()
		
		if json.parse(file.get_as_text()) == OK:
			return json.get_data()
