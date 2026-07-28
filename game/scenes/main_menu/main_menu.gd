extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var menu_options: VBoxContainer = $menu_options

func _ready() -> void:
	_play_intro()
	
	for btn in menu_options.get_children():
		btn.pressed.connect(_on_option_pressed.bind(btn))
		
	Signals.account_connected.connect(_on_account_connected)

func _check_account_connected():	
	if SaveManager.account_connected:
		$sign_in.text = SaveManager.get_player_username()
	
func _on_option_pressed(btn: Button):
	match btn.name:
		"play":
			Signals.change_screen.emit("game")
		"settings":
			Signals.change_screen.emit("settings")
		"quit":
			SaveManager.safe_exit()

func _enable_btns():
	for btn in menu_options.get_children():
		btn.disabled = false
		
	$sign_in.disabled = false

func _play_intro():
	animation_player.play("intro_sequence")
	
	_check_account_connected()
	
	await animation_player.animation_finished

func on_screen_change():
	GameManager.disable_autosave()

func _on_sign_in_pressed() -> void:
	if not SaveManager.account_connected:
		Signals.show_modal.emit("confirm_sign_in")
		
		var confirmation = await Signals.modal_response
		
		if confirmation:
			Signals.change_screen.emit("online_save")
	else:
		Signals.show_modal.emit("redirect_to_website")
		
		var confirmation = await Signals.modal_response
		
		if confirmation:
			OS.shell_open(Constants.WEBSITE_URL)

func _on_account_connected(username):
	$sign_in.text = username
