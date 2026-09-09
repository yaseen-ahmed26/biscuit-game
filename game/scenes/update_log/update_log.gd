extends Control

@onready var versions_btns: VBoxContainer = $versions
@onready var added: VBoxContainer = $ScrollContainer/VBoxContainer/added
@onready var changed: VBoxContainer = $ScrollContainer/VBoxContainer/changed
@onready var removed: VBoxContainer = $ScrollContainer/VBoxContainer/removed
@onready var template: RichTextLabel = $ScrollContainer/VBoxContainer/template

var on_screen: bool = false
var update_info: Dictionary

func _ready() -> void:
	update_info = GameManager.read_json("res://data/update_log.json")
	var latest = update_info.get("latest")
	_setup_log(latest)

func _clear_log_children():
	for child in added.get_children():
		child.queue_free()
	
	for child in changed.get_children():
		child.queue_free()
		
	for child in removed.get_children():
		child.queue_free()

func _add_entry_to_log(text: String, parent: VBoxContainer):
	var clone: RichTextLabel = template.duplicate()
		
	parent.add_child(clone)
	
	clone.text = text
	clone.name = "1"
	clone.visible = true

func _setup_log(btn_name: String):
	var info = update_info.get(btn_name)
	if not info: 
		push_warning("Failed to get update information for " + btn_name) 
		return

	_clear_log_children()
	
	for s in info.get("added"):
		_add_entry_to_log(s, added)
		
	for s in info.get("changed"):
		_add_entry_to_log(s, changed)
		
	for s in info.get("removed"):
		_add_entry_to_log(s, removed)

func on_screen_change():
	on_screen = true

func _on_return_btn_pressed() -> void:
	on_screen = false
	
	Signals.change_screen.emit("main_menu")
