extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var menu_options: VBoxContainer = $background/menu_options

const CONFIG_FILE_PATH: String = "user://config.cfg"

var config: ConfigFile = ConfigFile.new()
var action_on_play: String

func _ready() -> void:
	config.set_value("DeviceConfig", "save_type", "pick")
	config.save(CONFIG_FILE_PATH)
	
	_play_intro()
	
	for btn in menu_options.get_children():
		btn.pressed.connect(_on_option_pressed.bind(btn))

func _find_save():
	if FileAccess.file_exists(CONFIG_FILE_PATH):		
		var error = config.load(CONFIG_FILE_PATH)
		
		if error != OK:
			print("An error occurred whilst laoding existing config file: ", error)
			action_on_play = "pick"
			return
			
		action_on_play = config.get_value("DeviceConfig", "save_type", "pick")
		
		if action_on_play == "pick":
			$background/menu_options/play.text = "NEW GAME"
		else:
			$background/menu_options/play.text = "PLAY"
	else:
		$background/menu_options/play.text = "NEW GAME"
		action_on_play = "pick"
		config.save(CONFIG_FILE_PATH)
	print(action_on_play)
	
func _on_option_pressed(btn: Button):
	match btn.name:
		"play":
			if action_on_play == "pick":
				Signals.change_screen.emit("pick_save")
			elif action_on_play == "online":
				Signals.change_screen.emit("online_save")
			elif action_on_play == "local":
				print("local not yet made")
		"quit":
			get_tree().quit()

func _play_intro():
	animation_player.play("intro_sequence")
	
	_find_save()
	
	await animation_player.animation_finished
