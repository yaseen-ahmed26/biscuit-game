extends Node

# Variables
var device_config: ConfigFile = ConfigFile.new()
var save_config: ConfigFile = ConfigFile.new()

var save_type = "none"

var default_stats: Dictionary

var methods: Dictionary[String, Dictionary] = {
	"load": {
		"online": _load_online,
		"local": _load_local
	},
	"save": {
		"online": _save_online,
		"local": _save_local
	},
	"setup": {
		"online": _setup_online,
		"local": _setup_local
	}
}

# Godot
func _ready() -> void:
	default_stats = GameManager.read_json(Constants.DEFAULT_STATS_FILE_PATH)
	
	_check_save_type()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		safe_exit()

# Helpers
func _check_config_exists(file_path) -> bool:
	if FileAccess.file_exists(file_path):
		return true
		
	return false

# Online Saves
func _load_online():
	var error = device_config.load(Constants.DEVICE_CFG_FILE_PATH)

	if error != OK:
		print("An error occurred whilst laoding existing save file: ", error)
		return [false]
	
	var save_id: String = device_config.get_value("DeviceConfig", "save_id")
		
	if not save_id:
		print("No save ID found")
		return [false]
		
	var saved_stats = await RequestManager.get_saved_data(save_id)
	
	if not saved_stats:
		print("An error occurred getting save data")
		return [false]
	
	return [true, saved_stats]
	
func _save_online(data):
	var save_id = device_config.get_value("DeviceConfig", "save_id")
	var _success = await RequestManager.send_put_request(save_id, data)
	
func _setup_online(data):
	save_type = "online"
	
	device_config.set_value("DeviceConfig", "save_type", "online")
	device_config.set_value("DeviceConfig", "save_id", data.save_id)
	device_config.set_value("DeviceConfig", "player_username", data.username)

	device_config.save(Constants.DEVICE_CFG_FILE_PATH)
	
	await _save_online(data.save)
	load_game()
	
	return true

# Local Saves
func _load_local():	
	var save_cfg_exists = _check_config_exists(Constants.SAVE_CFG_FILE_PATH)
	
	if not save_cfg_exists:
		print("save.cfg does not exist")
		return [false]
		
	var error = save_config.load(Constants.SAVE_CFG_FILE_PATH)

	if error != OK:
		print("An error occurred whilst laoding existing save file: ", error)
		return [false]
		
	var save_data: Array = save_config.get_section_keys("LocalSave")
	
	if not save_data:
		print("No 'LocalSave' section found in save.cfg")
		return [false]
		
	var saved_stats = {}
	
	for k in save_data:
		var v = save_config.get_value("LocalSave", k)
		
		saved_stats[k] = v
	
	return [true, saved_stats]
	
func _save_local(stats):
	for k in stats.keys():
		var v = stats.get(k)
		
		save_config.set_value("LocalSave", k, v)
		
	save_config.save(Constants.SAVE_CFG_FILE_PATH)
	
func _setup_local(data):
	save_type = "local"
	
	device_config.set_value("DeviceConfig", "save_type", "local")
	device_config.set_value("DeviceConfig", "player_username", data.username)
	
	device_config.save(Constants.DEVICE_CFG_FILE_PATH)
	
	_save_local(default_stats)
	load_game()
	
	return true

# Routers
func load_game():
	var method = methods.load.get(save_type)
	var details = await method.call()
	
	var loaded_data = {}
	
	if details[0]:
		loaded_data = details[1]
	else:
		push_error("Fatal Error: Failed to load saved data")
		loaded_data = default_stats
		
	PlayerManager.set_runtime_stats(loaded_data)

func save_game():
	var data_to_save = PlayerManager.get_data_to_save()
	
	var method = methods.save.get(save_type)
	var success = await method.call(data_to_save)
	
	assert(not success, "Fatal Error: Failed to save game")
	
	Signals.data_saved.emit()

func setup_game(type_picked: String, data):
	var method = methods.setup.get(type_picked)
	method.call(data)

# Main
func _check_save_type():
	var device_cfg_exists = _check_config_exists(Constants.DEVICE_CFG_FILE_PATH)
	
	if not device_cfg_exists:
		print("No device.cfg file found")
		return
		
	var error = device_config.load(Constants.DEVICE_CFG_FILE_PATH)
		
	if error != OK:
		print("An error occurred whilst laoding existing config file: ", error)
		return
		
	save_type = device_config.get_value("DeviceConfig", "save_type")

	load_game()

func safe_exit():
	set_process(false)
	await save_game()
	get_tree().quit()
