extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var menu_options: VBoxContainer = $menu_options

func _ready() -> void:
	_play_intro()
	
	for btn in menu_options.get_children():
		btn.pressed.connect(_on_option_pressed.bind(btn))

func _change_start_btn():	
	if SaveManager.save_type == "online" or SaveManager.save_type == "local":
		$menu_options/play.text = "PLAY"
	else:
		$menu_options/play.text = "NEW GAME"
	
func _on_option_pressed(btn: Button):
	match btn.name:
		"play":
			if SaveManager.save_type != "none":
				Signals.change_screen.emit("game")
			else:
				Signals.change_screen.emit("pick_save")
		"settings":
			Signals.change_screen.emit("settings")
		"quit":
			SaveManager.safe_exit()

func _enable_btns():
	for btn in menu_options.get_children():
		btn.disabled = false

func _play_intro():
	animation_player.play("intro_sequence")
	
	_change_start_btn()
	
	await animation_player.animation_finished
