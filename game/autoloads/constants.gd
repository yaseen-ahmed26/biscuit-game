extends Node

# GameManager
const AUTOSAVE_TIMER: float = 15.0

# SaveManager
const DEVICE_CFG_FILE_PATH: String = "user://device.cfg"
const SAVE_CFG_FILE_PATH: String = "user://save.cfg"
const DEFAULT_STATS_FILE_PATH = "res://data/default_stats.json"

# local_save.gd
const MIN_USERNAME_LENGTH: int = 4
const MAX_USERNAME_LENGTH: int = 24

# online_save.gd
const COUNTRIES: Dictionary[String, String] = {
	"GB": "United Kingdom"
}

# upgrade_screen.gd
const UPGRADES_FILE_PATH = "res://data/upgrades.json"
const OPEN_POSITION: Vector2 = Vector2(4.0, 459.0)
const HIDDEN_POSITION: Vector2 = Vector2(4.0, 1086.0)

# Global
const SECRETS_PATH: String = "res://secrets.json"
