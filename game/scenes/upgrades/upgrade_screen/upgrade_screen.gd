extends Control

@onready var holder: VBoxContainer = $ScrollContainer/holder

const UPGRADES_FILE_PATH = "res://data/upgrades.json"
const OPEN_POSITION: Vector2 = Vector2(4.0, 459.0)
const HIDDEN_POSITION: Vector2 = Vector2(4.0, 1086.0)

var open: bool = false

var upgrade_data: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_data = GameManager.read_json(UPGRADES_FILE_PATH)
	
	_set_upgrade_lines()

func _set_upgrade_lines():
	var total_upgrades = upgrade_data.size()
	
	for i in total_upgrades:
		var upgrade = upgrade_data[i]
		
		var line = holder.get_node_or_null(str(i))
		
		if line:
			line.call("set_up_line", upgrade, 0)
		else:
			push_warning("Not enough upgrade lines")

func _on_open_btn_pressed() -> void:
	var use_position: Vector2
	
	if open:
		use_position = HIDDEN_POSITION
		open = false
	else:
		use_position = OPEN_POSITION
		open = true
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", use_position, 0.3)
