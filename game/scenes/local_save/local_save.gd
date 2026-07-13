extends Control

@onready var user_input: LineEdit = $user_input
@onready var continue_btn: Button = $continue
@onready var pick_user: RichTextLabel = $pick_user

func _ready() -> void:
	pass

func _change_message(message: String = "An error occurred", colour: String = "white"):
	pick_user.text = "[color=%s]%s" % [colour, message]

	#await get_tree().create_timer(2.0).timeout

	#pick_user.text = "[color=white]Choose a username"

func _on_user_input_text_changed(new_text: String) -> void:
	continue_btn.disabled = true

	if new_text.is_empty():
		_change_message("Choose a username")
	elif new_text.length() < 5:
		_change_message("Username must be at least 5 characters long", "red")
	elif new_text.length() > 24:
		_change_message("Username cannot be longer than 24 characters", "red")
	elif new_text.contains(" "):
		_change_message("Username cannot have any spaces", "red")
	else:
		continue_btn.disabled = false
		_change_message("Username is valid", "green")

func _on_continue_btn_pressed():
	SaveManager.setup_game("local", {"username": user_input.text})
	Signals.change_screen.emit("game")
