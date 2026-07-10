extends Control

@onready var icon: TextureRect = $icon
@onready var info_panel: Panel = $info_panel
@onready var upgrade_name: RichTextLabel = $upgrade_name
@onready var description: RichTextLabel = $description
@onready var levels: VBoxContainer = $levels

var upgrade_data: Dictionary
var current_level: int

var green_panel: StyleBoxFlat = preload("res://resources/panels/green.tres")

func _get_current_level_data():
	return upgrade_data.levels[current_level]

func _display_level():
	if current_level == upgrade_data.total_levels:
		$buy_btn.text = "MAX"
		$buy_btn.disabled = true
		return
	
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
	self.set_meta("group", data.group)
	self.name = data.id
	
	_display_level()

func _on_buy_btn_pressed():
	var level_info: Dictionary = _get_current_level_data()
	
	if PlayerManager.can_purchase(level_info.cost):
		var panel: Panel = levels.get_node(str(current_level + 1))
		panel.add_theme_stylebox_override("panel", green_panel)
		
		current_level += 1
		PlayerManager.apply_effect(level_info.effect)
		_display_level()
	else:
		print("not enough")
