extends Node

# GameManager
const AUTOSAVE_TIMER: float = 20.0

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

# game.gd
const EFFECT_LINGER_TIME: float = 1.0
const EFFECT_FADE_TIME: float = 0.5
const EFFECT_ENTRY_TIME: float = 0.4
const EFFECT_COLOURS: Dictionary = {
	"REGULAR": Color.WHITE,
	"x2 CHANCE": Color.GOLD,
	"MILE STONE": Color.GREEN,
}

# ui_controller.gd
const MESSAGES: Dictionary = {
	"unlink_account": {
		"title": "WARNING",
		"primary": "You are about to unlink this device from your online account. This does not erase your data.",
		"secondary": "You must connect your account again via an invite code.",
		"btn": "Proceed"
	},
	"no_data": {
		"title": "FATAL ERROR",
		"primary": "Your save data could not be retrieved from the server. Any progress you make will not be saved.",
		"secondary": "Your existing data has not been deleted, please try logging on later.",
		"btn": "Got it"
	},
	"invalid_online_id": {
		"title": "FATAL ERROR",
		"primary": "The Save ID associated with your account is invalid. Any progress you make will not be saved.",
		"secondary": "Navigate to settings then click 'Switch Account' to relink your account.",
		"btn": "Got it"
	},
	"account_link": {
		"title": "LINK SUCCESS",
		"primary": "Hello, %s!",
		"secondary": "Successfully linked your account! You can log into other devices and access your data from there.",
		"btn": "Start Game"
	}
}

# Global
const SECRETS_PATH: String = "res://secrets.json"
