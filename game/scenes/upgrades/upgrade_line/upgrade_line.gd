extends Control

@onready var icon: TextureRect = $icon
@onready var info_panel: Panel = $info_panel
@onready var upgrade_name: RichTextLabel = $upgrade_name
@onready var description: RichTextLabel = $description
@onready var levels: VBoxContainer = $levels

var upgrade_data: Dictionary
var current_level: int = 0

var red_panel: StyleBoxFlat = preload("res://resources/panels/red.tres")
var green_panel: StyleBoxFlat = preload("res://resources/panels/green.tres")
var gold_panel: StyleBoxFlat = preload("res://resources/panels/gold.tres")

func _get_current_level_data():
	return upgrade_data.levels[current_level]

func _set_all_panels_red():
	for panel in levels.get_children():
		panel.add_theme_stylebox_override("panel", red_panel)

func _display_level():
	if current_level >= upgrade_data.total_levels:
		$buy_btn.text = "MAX"
		$buy_btn.disabled = true
		
		var panel: Panel = levels.get_node(str(current_level - 1))
		panel.add_theme_stylebox_override("panel", gold_panel)
		
		return
	
	var level_info: Dictionary = _get_current_level_data()
	
	$info_panel/level_name.text = level_info.name
	$info_panel/level_description.text = level_info.description
	$info_panel/level_cost.text = "%d Biscuits" % level_info.cost

	var panel: Panel = levels.get_node(str(current_level))
	panel.add_theme_stylebox_override("panel", green_panel)

func set_up_line(data: Dictionary, saved_level: int):
	print("Loading save data. Current saved level is ", saved_level)
	upgrade_data = data

	upgrade_name.text = data.name
	description.text = data.description
			
	self.set_meta("id", data.id)
	self.set_meta("group", data.group)
	self.name = data.id
	
	_set_all_panels_red()

	for i in range(0, saved_level + 1):
		current_level = i
		_display_level()

func reset_line():
	set_up_line(upgrade_data, 0)
	$buy_btn.text = "BUY"
	$buy_btn.disabled = false

func _on_buy_btn_pressed():
	var level_info: Dictionary = _get_current_level_data()
	
	if PlayerManager.can_purchase(level_info.cost):	
		current_level += 1
		PlayerManager.apply_effect(level_info.effect)
		PlayerManager.bought_upgrade(self.get_meta("id"), current_level)
		_display_level()
	else:
		print("not enough")
