extends Node

@export var online_save_scene: Control

@onready var hbox_container: HBoxContainer = $background/HBoxContainer
@onready var continue_btn: Button = $background/continue_btn

var type_selected: String

func _ready() -> void:
	for item in hbox_container.get_children():
		if not item is Button: continue
		
		item.pressed.connect(_save_selected.bind(item))
	
# UI stuff
func _save_selected(item: Button):
	type_selected = item.name
	continue_btn.disabled = false
	continue_btn.text = "Continue with " + type_selected.capitalize()
	
func _on_continue_btn_pressed():
	match type_selected:
		"online": 
			Signals.change_screen.emit("pick_save", "online_save")
			online_save_scene.call("start_websocket") 
		"local": pass
	
	continue_btn.disabled = true
