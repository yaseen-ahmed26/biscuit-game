extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var menu_options: VBoxContainer = $menu_options

var action: String

func _ready() -> void:
	_play_intro()
	
	for btn in menu_options.get_children():
		btn.pressed.connect(_on_option_pressed.bind(btn))

func _find_save():
	action = SaveManager.find_save_type()
	
	if action == "online" or action == "local":
		$menu_options/play.text = "PLAY"
	else:
		$menu_options/play.text = "NEW GAME"
	
func _on_option_pressed(btn: Button):
	match btn.name:
		"play":
			if action == "pick":
				Signals.change_screen.emit("pick_save")
			else:
				Signals.change_screen.emit("game")
		"settings":
			Signals.change_screen.emit("settings")
		"quit":
			get_tree().quit()

func _play_intro():
	animation_player.play("intro_sequence")
	
	_find_save()
	
	await animation_player.animation_finished
