extends Node

var device_config: ConfigFile = ConfigFile.new()
var save_config: ConfigFile = ConfigFile.new()

var default_stats: Dictionary

var autosave_count: int = 0

var account_connected: bool = false

# Godot
func _ready() -> void:
	default_stats = GameManager.read_json(Constants.DEFAULT_STATS_FILE_PATH)
	
	_load_cfg_files()
	_load_game()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		safe_exit()

# Helpers
func _check_cfg_exists(file_path):
	if FileAccess.file_exists(file_path):
		return true
		
	return false

func _load_cfg_files():
	var device_error = device_config.load(Constants.DEVICE_CFG_FILE_PATH)

	if device_error != OK:
		print("An error occurred whilst laoding 'device.cfg': ", device_error)

	var save_error = save_config.load(Constants.SAVE_CFG_FILE_PATH)

	if save_error != OK:
		print("An error occurred whilst laoding 'save.cfg': ", save_error)

func _setup_device_cfg():
	device_config.set_value("DeviceConfig", "connected_account", false)
	device_config.set_value("DeviceConfig", "save_id", "none")
	device_config.set_value("DeviceConfig", "player_username", "johndoe")

	device_config.save(Constants.DEVICE_CFG_FILE_PATH)
	
func _setup_save_cfg():
	for k in default_stats.keys():
		var v = default_stats.get(k)	
		save_config.set_value("LocalSave", k, v)

	save_config.save(Constants.SAVE_CFG_FILE_PATH)

# Online
func _load_online():
	var save_id: String = device_config.get_value("DeviceConfig", "save_id")
		
	if not save_id:
		print("No save ID found")
		return [false]
		
	var saved_stats = await RequestManager.get_saved_data(save_id)
	
	if not saved_stats:
		print("An error occurred getting save data")
		return [false]
	
	return [true, saved_stats]
	
func _save_online(data_to_save):
	var save_id = device_config.get_value("DeviceConfig", "save_id")
	var _success = await RequestManager.send_put_request(save_id, data_to_save)
	
func has_connected_account():
	return device_config.get_value("DeviceConfig", "connected_account", false)

func connect_account(user_data: Dictionary):
	device_config.set_value("DeviceConfig", "connected_account", true)
	device_config.set_value("DeviceConfig", "save_id", user_data.save_id)
	device_config.set_value("DeviceConfig", "player_username", user_data.username)

	device_config.save(Constants.DEVICE_CFG_FILE_PATH)
	
	_save_local(default_stats)
	_save_local(user_data.save)
	
	account_connected = true
	
	var load_details = _load_local()
	
	if load_details[0]:
		PlayerManager.set_runtime_stats(load_details[1])
	else:
		PlayerManager.set_runtime_stats(default_stats)
	
	Signals.account_connected.emit(user_data.username)

func get_player_username():
	return device_config.get_value("DeviceConfig", "player_username")

# Local
func _load_local():		
	var save_data: Array = save_config.get_section_keys("LocalSave")
	
	if not save_data:
		print("No LocalSave section found in 'save.cfg'")
		return [false]
	
	var saved_stats = {}
	
	for k in save_data:
		var v = save_config.get_value("LocalSave", k)
		
		saved_stats[k] = v
		
	return [true, saved_stats]
	
func _save_local(data_to_save):
	for k in data_to_save.keys():
		var v = data_to_save.get(k)
		save_config.set_value("LocalSave", k, v)
		
	save_config.save(Constants.SAVE_CFG_FILE_PATH)
	
	print("Saving to:")
	print(ProjectSettings.globalize_path(Constants.SAVE_CFG_FILE_PATH))

# Main
func _load_game():
	var saved_data = {}
	
	if not _check_cfg_exists(Constants.DEVICE_CFG_FILE_PATH):
		_setup_device_cfg()
		
	if not _check_cfg_exists(Constants.SAVE_CFG_FILE_PATH):
		_setup_save_cfg()
		
	if has_connected_account():
		account_connected = true
		var online_details = await _load_online()
		
		if online_details[0]:
			online_details[1].erase("save_id")
			_save_local(online_details[1])
		
	var local_details = _load_local()
	
	if local_details[0]:
		saved_data = local_details[1]
		
	PlayerManager.set_runtime_stats(saved_data)
	
func save_game(quit: bool = false):
	var online_autosave: bool = false
	autosave_count += 1
	
	var data_to_save = PlayerManager.get_data_to_save()
	_save_local(data_to_save)
	
	if autosave_count == Constants.ONLINE_SAVE_THRESHOLD:
		if account_connected:
			await _save_online(data_to_save)
			online_autosave = true
			
		autosave_count = 0
	
	if quit and not online_autosave:
		if account_connected:
			await _save_online(data_to_save)

# Contingency
func safe_exit():
	set_process(false)
	await save_game(true)
	get_tree().quit()
