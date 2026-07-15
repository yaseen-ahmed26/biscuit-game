extends Control

@onready var icon: TextureRect = $icon
@onready var info_panel: Panel = $info_panel
@onready var upgrade_name: RichTextLabel = $upgrade_name
@onready var description: RichTextLabel = $description
@onready var levels: VBoxContainer = $levels

var red_panel: StyleBoxFlat = preload("res://resources/panels/red.tres")
var green_panel: StyleBoxFlat = preload("res://resources/panels/green.tres")
var gold_panel: StyleBoxFlat = preload("res://resources/panels/gold.tres")

var upgrade_data: Dictionary
var current_level: int = 0

func _get_current_level_data():
	return upgrade_data.levels[current_level]

func _update_panel(panel_name, colour):
	var panel: Panel = levels.get_node(panel_name)
	panel.add_theme_stylebox_override("panel", colour)
	
	var cost_label = panel.get_node("cost")
		
	cost_label.text = "BOUGHT"

func _apply_effect():
	var level_info: Dictionary = _get_current_level_data()
	
	_update_panel(str(current_level), green_panel)
	
	current_level += 1
	PlayerManager.apply_effect(level_info.effect)
	PlayerManager.bought_upgrade(self.get_meta("id"), current_level)

func _update_ui():
	if current_level >= upgrade_data.total_levels:
		_update_panel(str(current_level - 1), gold_panel)
		
		$info_panel/level_name.visible = false
		$info_panel/level_description.visible = false
		$info_panel/level_cost.visible = false
		
		$buy_btn.disabled = true
		$buy_btn.text = "COMPLETE"
		
		return
	
	var level_info: Dictionary = _get_current_level_data()
	
	$info_panel/level_name.text = level_info.name
	$info_panel/level_description.text = level_info.description
	$info_panel/level_cost.text = "%d Biscuits" % level_info.cost

func reset_line():
	set_up_line(upgrade_data, 0)
	$buy_btn.text = "BUY"
	$buy_btn.disabled = false
	
	$info_panel/level_name.visible = true
	$info_panel/level_description.visible = true
	$info_panel/level_cost.visible = true

func set_up_line(data, saved_level):
	var level_data = data.levels
	
	current_level = 0
	
	upgrade_data = data

	upgrade_name.text = data.name
	description.text = data.description
			
	self.set_meta("id", data.id)
	self.set_meta("group", data.group)
	self.name = data.id
	
	for panel in levels.get_children():
		panel.add_theme_stylebox_override("panel", red_panel)
		var cost_label = panel.get_node("cost")
		
		cost_label.text = "%d Biscuits" % level_data[int(panel.name)].get("cost")
	
	for i in range(0, saved_level):
		_apply_effect()
	
	_update_ui()

func _on_buy_btn_pressed():
	var level_info: Dictionary = _get_current_level_data()
	
	if PlayerManager.can_purchase(level_info.cost):	
		_apply_effect()
		_update_ui()
	else:
		print("not enough")

"""extends Control

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

func _buy_level():
	var level_info: Dictionary = _get_current_level_data()
	
	current_level += 1
	PlayerManager.apply_effect(level_info.effect)
	PlayerManager.bought_upgrade(self.get_meta("id"), current_level)
	_display_level()

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
	upgrade_data = data

	upgrade_name.text = data.name
	description.text = data.description
			
	self.set_meta("id", data.id)
	self.set_meta("group", data.group)
	self.name = data.id
	
	_set_all_panels_red()
	
	if saved_level == 0:
		_display_level()
		return
	
	for i in range(0, saved_level):
		_buy_level()

func reset_line():
	set_up_line(upgrade_data, 0)
	$buy_btn.text = "BUY"
	$buy_btn.disabled = false

func _on_buy_btn_pressed():
	var level_info: Dictionary = _get_current_level_data()
	
	if PlayerManager.can_purchase(level_info.cost):	
		_buy_level()
	else:
		print("not enough")
"""
