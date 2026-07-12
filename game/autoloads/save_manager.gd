extends Node

const DEVICE_CFG_FILE_PATH: String = "user://device.cfg"
const SAVE_CFG_FILE_PATH: String = "user://save.cfg"
const DEFAULT_STATS_FILE_PATH = "res://data/default_stats.json"

var device_config: ConfigFile = ConfigFile.new()
var save_config: ConfigFile = ConfigFile.new()

var action: String
var online_save_id: String
var online_save_data: Dictionary = {}

var last_saved: float

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	
func setup_online_save(data):
	action = "online"
	
	device_config.set_value("DeviceConfig", "save_type", "online")
	device_config.set_value("DeviceConfig", "save_id", data.save_id)
	device_config.set_value("DeviceConfig", "player_username", data.username)
	
	online_save_data = data.save
	
	load_and_save()
	
	device_config.save(DEVICE_CFG_FILE_PATH)
	
func setup_local_save(data):
	action = "local"
	
	device_config.set_value("DeviceConfig", "save_type", "local")
	device_config.set_value("DeviceConfig", "player_username", data.username)
	
	load_and_save()
	
	device_config.save(DEVICE_CFG_FILE_PATH)
	
func store_online_save(data):
	var save_id = device_config.get_value("DeviceConfig", "save_id")
	var success = await RequestManager.send_put_request(save_id, data)	
	
	if success:
		pass
	
func store_local_save(data):
	for k in data.keys():
		var v = data.get(k)
		
		save_config.set_value("LocalSave", k, v)
		
	save_config.save(SAVE_CFG_FILE_PATH)
	
func load_online_save():
	if online_save_id == "none":
		action = "pick"
		return
		
	if not online_save_data.is_empty():
		Signals.data_loaded.emit(online_save_data)
		return
		
	var save_id = device_config.get_value("DeviceConfig", "save_id")
		
	var saved_data = await RequestManager.get_saved_data(save_id)
	
	Signals.data_loaded.emit(saved_data)
	
func load_local_save():	
	var stats = GameManager.read_json(DEFAULT_STATS_FILE_PATH)
	
	if FileAccess.file_exists(SAVE_CFG_FILE_PATH):
		var error = save_config.load(SAVE_CFG_FILE_PATH)
		
		if error != OK:
			print("An error occurred whilst laoding existing save file: ", error)
		else:
			var save_data: Array = save_config.get_section_keys("LocalSave")
			
			if not save_data:
				print("No 'LocalSave' section found in save.cfg")
			else:
				for k in save_data:
					var v = save_config.get_value("LocalSave", k)
					
					stats[k] = v
	
	Signals.data_loaded.emit(stats)

func save_game():
	var data_to_save: Dictionary = PlayerManager.get_data_to_save()
	
	match action:
		"local": store_local_save(data_to_save)
		"online": await store_online_save(data_to_save)
		
	Signals.data_saved.emit()
		
func load_game():
	match action:
		"local": load_local_save()
		"online": load_online_save()
		
func load_and_save():
	load_game()
	save_game()

func delete_config_file(file_path):
	if FileAccess.file_exists(file_path):
		var error = DirAccess.remove_absolute(file_path)
		
		if error == OK:
			return true
		else:
			print("Failed to delete the file. ", error)
	else:
		print("File does not exist")
		
	return false

func reset_data():	
	var delete_config_success = delete_config_file(DEVICE_CFG_FILE_PATH)
	var delete_save_success = delete_config_file(SAVE_CFG_FILE_PATH)
	
	if delete_config_success and delete_save_success:
		Signals.change_screen.emit("pick_save")
	else:
		push_error("Fatal Error: Failed to delete either device.cfg or save.cfg")

func find_save_type():
	if FileAccess.file_exists(DEVICE_CFG_FILE_PATH):
		var error = device_config.load(DEVICE_CFG_FILE_PATH)
		
		if error != OK:
			print("An error occurred whilst laoding existing config file: ", error)
			action = "pick"
		else:
			action = device_config.get_value("DeviceConfig", "save_type", "pick")
			
			if action == "online":
				online_save_id = device_config.get_value("DeviceConfig", "save_id", "none")
	else:
		action = "pick"
	
	load_game()

	return action
	
func update_action(new_action: String):
	action = new_action
	
	load_game()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		safe_exit()

func safe_exit():
	set_process(false)
	await save_game()
	get_tree().quit()
