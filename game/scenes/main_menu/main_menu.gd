extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var menu_options: VBoxContainer = $background/menu_options

const CONFIG_FILE_PATH: String = "user://config.cfg"

var config: ConfigFile = ConfigFile.new()
var action: String

func _ready() -> void:
	_play_intro()
	
	for btn in menu_options.get_children():
		btn.pressed.connect(_on_option_pressed.bind(btn))

func _find_save():
	action = SaveManager.find_save_type()
	
	if action == "online" or action == "local":
		$background/menu_options/play.text = "PLAY"
	else:
		$background/menu_options/play.text = "NEW GAME"
	
func _on_option_pressed(btn: Button):
	match btn.name:
		"play":
			if action == "pick":
				Signals.change_screen.emit("pick_save")
			elif action == "online":
				Signals.change_screen.emit("online_save")
			elif action == "local":
				print("local not yet made")
		"quit":
			get_tree().quit()

func _play_intro():
	animation_player.play("intro_sequence")
	
	_find_save()
	
	await animation_player.animation_finished
