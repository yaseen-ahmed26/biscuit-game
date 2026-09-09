extends Control

@export var upgrade_pool: Array[UpgradeBase]

@onready var holder: VBoxContainer = $ScrollContainer/holder
@onready var counter: RichTextLabel = $counter

var upgrade_line: PackedScene = preload("res://scenes/upgrades/upgrade_line/upgrade_line.tscn")
var open: bool = false

func _ready() -> void:	
	Signals.data_loaded.connect(_on_data_loaded)
	Signals.stats_changed.connect(_on_stats_changed)
	
	if PlayerManager.stats_loaded:
		_set_upgrade_lines()

func _set_upgrade_lines():
	var saved_upgrades = PlayerManager.runtime_stats.owned_upgrades
	
	for upgrade in upgrade_pool:
		var saved_level = 0
		
		if saved_upgrades.get(upgrade.id):
			saved_level = saved_upgrades[upgrade.id]
		
		var clone = upgrade_line.instantiate()
		holder.add_child(clone)
		
		clone.name = upgrade.id
		clone.setup(upgrade, saved_level)

func _on_open_btn_pressed() -> void:
	var use_position: Vector2
	
	if open:
		use_position = Constants.HIDDEN_POSITION
		open = false
	else:
		use_position = Constants.OPEN_POSITION
		open = true
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", use_position, 0.3)

func _on_data_loaded(data):
	_set_upgrade_lines()
	_on_stats_changed(data)

func _on_stats_changed(_data):
	var can_afford: int = 0
	
	for line in holder.get_children():
		if line.can_purchase():
			can_afford += 1
	
	counter.text = "%d/4" % can_afford
