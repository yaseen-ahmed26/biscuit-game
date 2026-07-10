extends Node

const CONFIG_FILE_PATH: String = "user://config.cfg"
const SAVE_FILE_PATH: String = "user://save.cfg"

var config: ConfigFile = ConfigFile.new()
var action: String

var save_id: String

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)

func store_online_data(data):
	config.set_value("DeviceConfig", "save_type", "online")
	config.set_value("DeviceConfig", "save_id", data.save_id)
	config.set_value("DeviceConfig", "player_username", data.username)
	
	config.save(CONFIG_FILE_PATH)

func store_local_save(data):
	config.set_value("DeviceConfig", "save_type", "local")
	config.set_value("DeviceConfig", "player_username", data.username)
	
	config.save(CONFIG_FILE_PATH)

func local_save(data_to_save: Dictionary):
	var save_config: ConfigFile = ConfigFile.new()
	
	for k in data_to_save.keys():
		var v = data_to_save.get(k)
		
		save_config.set_value("LocalSave", k, v)
		
	save_config.save(SAVE_FILE_PATH)
	
func online_save():
	pass

func _get_local_save():
	var save_config: ConfigFile = ConfigFile.new()
	
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var error = save_config.load(SAVE_FILE_PATH)
		
		if error != OK:
			print("An error occurred whilst laoding existing save file: ", error)
			action = "pick"
			return
			
		var save_data: Array = save_config.get_section_keys("LocalSave")
		var stats = {}
		
		for k in save_data:
			var v = save_config.get_value("LocalSave", k)
			
			stats[k] = v
			
		Signals.data_loaded.emit(stats)
	else:
		save_config.save(SAVE_FILE_PATH)
	
func _get_online_save():
	if save_id == "none":
		action = "pick"
		return
	
func _get_save_data():
	match action:
		"local": _get_local_save()
		"online": _get_online_save()
		"pick": pass

func find_save_type() -> String:
	if FileAccess.file_exists(CONFIG_FILE_PATH):
		var error = config.load(CONFIG_FILE_PATH)
		
		if error != OK:
			print("An error occurred whilst laoding existing config file: ", error)
			action = "pick"
		else:
			action = config.get_value("DeviceConfig", "save_type", "pick")
			
			if action == "online":
				save_id = config.get_value("DeviceConfig", "save_id", "none")
	else:
		action = "pick"
		config.save(CONFIG_FILE_PATH)
	
	_get_save_data()

	return action

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		var data_to_save: Dictionary = PlayerManager.get_data_to_save()
		
		match action:
			"local": local_save(data_to_save)
