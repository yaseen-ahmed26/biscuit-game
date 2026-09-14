extends Node

# GameManager
const AUTOSAVE_TIMER: float = 10.0

# SaveManager
const DEVICE_CFG_FILE_PATH: String = "user://device.cfg"
const SAVE_CFG_FILE_PATH: String = "user://save.cfg"
const DEFAULT_STATS_FILE_PATH = "res://data/default_stats.json"
const ONLINE_SAVE_THRESHOLD: int = 1

# PlayerManager
const DEFAULT_RUNTIME_STATS: Dictionary = {
	"per_click": 1.0,
	"multiplier": 1.0,
	"double_chance": 0.0000001,
	"bonus_per_milestone": 35,
	"click_milestone_bonus": 2.0,
	"active_boosts": [],
	
	"biscuits": 0.0,
	"total_biscuits": 0.0,
	"total_clicks": 0,
	"owned_upgrades": {},
	"owned_achievements": [],
	"prestige": 0,
	"crumbs": 0,
	"owned_unlocks": []
}
const FILTER_STATS_FOR_SAVE: Array = [
	"per_click",
	"multiplier",
	"double_chance",
	"bonus_per_milestone",
	"click_milestone_bonus",
	"active_boosts"
]

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

# boosts_screen.gd
const BOOSTS_FILE_PATH = "res://data/boosts.json"
const BOOSTS_OPEN_POSITION: Vector2 = Vector2(751.0, 712.0)
const BOOSTS_HIDDEN_POSITION: Vector2 = Vector2(751.0, 1086.0)

# game.gd
const EFFECT_LINGER_TIME: float = 1.0
const EFFECT_FADE_TIME: float = 0.5
const EFFECT_ENTRY_TIME: float = 0.4
const EFFECT_COLOURS: Dictionary = {
	"REGULAR": Color.WHITE,
	"x2 CHANCE": Color.GOLD,
	"MILE STONE": Color.GREEN,
}

# Global
const SECRETS_PATH: String = "res://secrets.json"
const WEBSITE_URL: String = "https://yaseen-ahmed26.github.io/biscuit-website/"
