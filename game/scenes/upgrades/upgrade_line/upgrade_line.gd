extends Control

@onready var icon: TextureRect = $icon
@onready var info_panel: Panel = $info_panel
@onready var upgrade_name: RichTextLabel = $upgrade_name
@onready var description: RichTextLabel = $description

var upgrade_data: Dictionary
var current_level: int

func _ready() -> void:
	# TEMPORARY

	if FileAccess.file_exists("res://data/upgrades.json"):
		var file = FileAccess.open("res://data/upgrades.json", FileAccess.READ)
		var json = JSON.new()
		
		if json.parse(file.get_as_text()) == OK:
			var data = json.get_data()
			
			set_up_line(data[0], 0)

func _get_current_level_data():
	return upgrade_data.levels[current_level]

func _display_level():
	var level_info: Dictionary = _get_current_level_data()
	
	$info_panel/level_name.text = level_info.name
	$info_panel/level_description.text = level_info.description
	$info_panel/level_cost.text = "%d Biscuits" % level_info.cost

func set_up_line(data: Dictionary, saved_level: int):
	upgrade_data = data
	current_level = saved_level
	
	upgrade_name.text = data.name
	description.text = data.description
	
	self.set_meta("id", data.id)
	_display_level()

func _on_buy_btn_pressed():
	var level_info: Dictionary = _get_current_level_data()
	
	if PlayerManager.can_purchase(level_info.cost):
		current_level += 1
		PlayerManager.apply_effect(level_info.effect)
		_display_level()
	else:
		print("not enough")
