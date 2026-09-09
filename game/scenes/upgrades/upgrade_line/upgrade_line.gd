extends Control

@onready var info_panel: Panel = $info_panel
@onready var upgrade_name: RichTextLabel = $upgrade_name
@onready var description: RichTextLabel = $description
@onready var levels: VBoxContainer = $levels

var red_panel: StyleBoxFlat = preload("res://resources/panels/red.tres")
var green_panel: StyleBoxFlat = preload("res://resources/panels/green.tres")
var gold_panel: StyleBoxFlat = preload("res://resources/panels/gold.tres")

var upgrade_data: UpgradeBase
var current_level: int = 0

func _get_current_level_data():
	return upgrade_data.levels[current_level]

func _update_panel(panel_name, colour):
	var panel: Panel = levels.get_node(panel_name)
	panel.add_theme_stylebox_override("panel", colour)
	
	var cost_label = panel.get_node("cost")
		
	cost_label.text = "BOUGHT"

func _apply_effect():
	var level_info = _get_current_level_data()
	
	_update_panel(str(current_level), green_panel)
	
	current_level += 1
	PlayerManager.apply_stat_change(level_info)
	PlayerManager.upgrade_bought(self.get_meta("id"), current_level)

func _update_ui():
	if current_level >= 5:
		_update_panel(str(current_level - 1), gold_panel)
		
		$info_panel/level_name.visible = false
		$info_panel/level_description.visible = false
		$info_panel/level_cost.visible = false
		
		$buy_btn.disabled = true
		$buy_btn.text = "COMPLETE"
		
		return
	
	var level_info = _get_current_level_data()
	
	$info_panel/level_name.text = level_info.display_name
	$info_panel/level_description.text = level_info.description
	$info_panel/level_cost.text = "%d Biscuits" % level_info.cost

func reset_line():
	setup(upgrade_data, 0)
	$buy_btn.text = "BUY"
	$buy_btn.disabled = false
	
	$info_panel/level_name.visible = true
	$info_panel/level_description.visible = true
	$info_panel/level_cost.visible = true

func setup(data: UpgradeBase, saved_level):
	var level_data = data.levels
	
	current_level = 0
	
	upgrade_data = data

	upgrade_name.text = data.display_name
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
	var level_info = _get_current_level_data()
	
	if PlayerManager.has_enough(level_info.cost):	
		_apply_effect()
		PlayerManager.decrease_biscuits(level_info.get("cost"))
		_update_ui()
	else:
		print("not enough")

func can_purchase():
	var level_info = _get_current_level_data()
	return PlayerManager.has_enough(level_info.cost)
