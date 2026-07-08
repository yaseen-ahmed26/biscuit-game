extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_play_intro()

func _play_intro():
	animation_player.play("intro_sequence")
	
	await animation_player.animation_finished
	
	Signals.change_screen.emit("main_menu", "pick_save")
