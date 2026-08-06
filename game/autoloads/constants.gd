extends Node

# GameManager
const AUTOSAVE_TIMER: float = 20.0

# SaveManager
const DEVICE_CFG_FILE_PATH: String = "user://device.cfg"
const SAVE_CFG_FILE_PATH: String = "user://save.cfg"
const DEFAULT_STATS_FILE_PATH = "res://data/default_stats.json"
const ONLINE_SAVE_THRESHOLD: int = 6

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

# ui_controller.gd
const MESSAGES: Dictionary = {
	"unlink_account": {
		"title": "[color=yellow]WARNING",
		"primary": "You are about to unlink this device from your online account. This does not erase your data.",
		"secondary": "You must connect your account again via an invite code.",
		"confirm": "Proceed",
		"cancel": "Cancel",
		"show_cancel_btn": true
	},
	"no_data": {
		"title": "[color=red]FATAL ERROR",
		"primary": "Your save data could not be retrieved from the server. Any progress you make will not be saved.",
		"secondary": "Your existing data has not been deleted, please try logging on later.",
		"confirm": "Got it",
		"show_cancel_btn": false
	},
	"invalid_online_id": {
		"title": "[color=red]FATAL ERROR",
		"primary": "The Save ID associated with your account is invalid. Any progress you make will not be saved.",
		"secondary": "Navigate to settings then click 'Switch Account' to relink your account.",
		"confirm": "Got it",
		"show_cancel_btn": false
	},
	"account_link": {
		"title": "[color=green]LINK SUCCESS",
		"primary": "[color=green]Hello, %s!",
		"secondary": "Successfully linked your account! You can log into other devices and access your data from there.",
		"confirm": "Start Game",
		"show_cancel_btn": false
	},
	"websocket_expired": {
		"title": "CODE EXPIRED",
		"primary": "The code has expired.",
		"secondary": "Click to continue online account linking, or cancel the link.",
		"confirm": "Continue",
		"cancel": "End",
		"show_cancel_btn": true
	},
	"confirm_sign_in": {
		"title": "NOTICE",
		"primary": "Connect your Biscuit account and save your game data online. Access your save from any device.",
		"secondary": "[color=red]Your existing local data will be lost when you connect your online account. This cannot be recovered.",
		"confirm": "Continue",
		"cancel": "Cancel",
		"show_cancel_btn": true
	},
	"redirect_to_website": {
		"title": "EXTERNAL",
		"primary": "Redirect to website?",
		"secondary": "You can view your game stats, edit your account details on the website.",
		"confirm": "Go to website",
		"cancel": "Cancel",
		"show_cancel_btn": true
	},
	"welcome_bonus": {
		"title": "[color=gold]BONUS",
		"primary": "Thank you for linking your account!",
		"secondary": "As a bonus, you start off with 100 biscuits and a +10% autoclicker rate. We hope you enjoy playing!",
		"confirm": "Can I start clicking now?",
		"show_cancel_btn": false
	}
}

# Global
const SECRETS_PATH: String = "res://secrets.json"
const WEBSITE_URL: String = "https://yaseen-ahmed26.github.io/biscuit-website/"
