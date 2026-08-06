extends Node

var runtime_stats: Dictionary = {}

var stats_loaded: bool = false
var original_values: Dictionary = {}
var milestone_click: int = 0

# Godot
func _ready() -> void:
	runtime_stats = Constants.DEFAULT_RUNTIME_STATS.duplicate(true)

# Helpers
func _get_chance(probability):
	return randf() < probability

func has_enough(target: float) -> bool:
	if runtime_stats.get("biscuits") >= target:
		return true
		
	return false

func apply_stat_change(effect: Dictionary):
	if not runtime_stats.has(effect.target):
		print("'%s' stat not found" % effect.target)
		return
	
	match effect.type:
		"add": runtime_stats[effect.target] += effect.value
		"subtract": runtime_stats[effect.target] -= effect.value
		"multiply": runtime_stats[effect.target] *= effect.value
		"divide": runtime_stats[effect.target] /= effect.value
		"set": runtime_stats[effect.target] = effect.value 
		
	Signals.stats_changed.emit(runtime_stats)

# Economy
func increase_biscuits(amount):
	runtime_stats["biscuits"] += amount
	runtime_stats["total_biscuits"] += amount
	
	Signals.stats_changed.emit(runtime_stats)
	
func decrease_biscuits(amount):
	runtime_stats["biscuits"] -= amount
	
	Signals.stats_changed.emit(runtime_stats)
	
func calculate_passive_biscuits():
	pass

# Unlockables
func cookie_click():
	var attribute: String = "REGULAR"
	
	runtime_stats["total_clicks"] += 1
	milestone_click += 1
	
	var amount = runtime_stats["per_click"] * runtime_stats["multiplier"]
	
	if _get_chance(runtime_stats["double_chance"]):
		amount *= 2
		attribute = "x2 CHANCE"
		
	if milestone_click == runtime_stats["bonus_per_milestone"]:
		milestone_click = 0
		amount *= runtime_stats["click_milestone_bonus"]
		attribute = "MILE STONE"
	
	increase_biscuits(amount)
	
	return [amount, attribute]

func upgrade_bought(upgrade_id: String, level: int):
	runtime_stats["owned_upgrades"][upgrade_id] = level

func apply_boost(effect, id):
	var active_boosts = runtime_stats.get("active_boosts")
	
	if active_boosts.has(id): return
	
	active_boosts.append(id)
	original_values[effect.target] = runtime_stats.get(effect.target)
	
	apply_stat_change(effect)
	
func boost_ended(effect, id: String):
	var active_boosts = runtime_stats.get("active_boosts")
	
	if not active_boosts.has(id): return
	
	active_boosts.erase(id)
	
	apply_stat_change({
		"type": "set",
		"target": effect.get("target"),
		"value": original_values.get(effect.target)
	})
	
	original_values.erase(id)
	
# Data
func get_data_to_save():
	var total_playtime: float = GameManager.get_time_played()
	var stats_to_save = {}
	
	for k in runtime_stats:
		if k in Constants.FILTER_STATS_FOR_SAVE:
			continue
		
		var v = runtime_stats[k]
		stats_to_save[k] = v
	
	stats_to_save["total_playtime"] = total_playtime

	return stats_to_save

func set_runtime_stats(save_stats: Dictionary):	
	var save_stats_duplicate = save_stats.duplicate(true)
	
	for k in save_stats_duplicate:
		var v = save_stats_duplicate.get(k)
		
		runtime_stats[k] = v
	
	stats_loaded = true
	Signals.data_loaded.emit(runtime_stats)
