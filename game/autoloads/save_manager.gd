extends Node

const CONFIG_FILE_PATH: String = "user://config.cfg"

var config: ConfigFile = ConfigFile.new()
var action: String

var save_id: String

func store_online_data(data):
	config.set_value("DeviceConfig", "save_type", "online")
	config.set_value("DeviceConfig", "save_id", data.save_id)
	config.set_value("DeviceConfig", "player_username", data.username)
	print("this is a test")
	config.save(CONFIG_FILE_PATH)

func _get_local_save():
	pass
	
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
