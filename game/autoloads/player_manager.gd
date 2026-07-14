extends Node

var runtime_stats: Dictionary = {
	"per_click": 1.0,
	"multiplier": 1.0,
	"double_chance": 0.0000001,
	"bonus_per_milestone": 35,
	"click_milestone_bonus": 2.0,
	
	"biscuits": 0.0,
	"total_biscuits": 0.0,
	"total_clicks": 0,
	"bought_upgrades": {},
	"completed_achievements": []
}

var milestone_click = 0

func _ready() -> void:
	Signals.data_loaded.connect(_on_data_loaded)

func apply_effect(effect: Dictionary):	
	if not runtime_stats[effect.target]:
		print("'%s' stat not found" % effect.target)
		Signals.stats_changed.emit(runtime_stats)
		return
	
	match effect.type:
		"add": runtime_stats[effect.target] += effect.value
		"subtract": runtime_stats[effect.target] -= effect.value
		"multiply": runtime_stats[effect.target] *= effect.value
		"divide": runtime_stats[effect.target] /= effect.value
		"set": runtime_stats[effect.target] = effect.value
		
	Signals.stats_changed.emit(runtime_stats)

func can_purchase(target: float) -> bool:
	if runtime_stats.get("biscuits") >= target:
		runtime_stats["biscuits"] -= target
		return true
		
	return false

func bought_upgrade(upgrade_id: String, level: int):
	runtime_stats["bought_upgrades"][upgrade_id] = level

func _get_chance(probability):
	return randf() < probability

func click_cookie():
	runtime_stats["total_clicks"] += 1
	milestone_click += 1
	
	var amount = runtime_stats["per_click"] * runtime_stats["multiplier"]
	
	if _get_chance(runtime_stats["double_chance"]):
		amount *= 2
		
	if milestone_click == runtime_stats["bonus_per_milestone"]:
		milestone_click = 0
		amount *= runtime_stats["click_milestone_bonus"]
	
	runtime_stats["biscuits"] += amount
	runtime_stats["total_biscuits"] += amount
	
	Signals.stats_changed.emit(runtime_stats)
	
	return amount

func get_data_to_save():
	var total_playtime: float = GameManager.get_time_played()
	
	var filter_stats = [
		"per_click",
		"multiplier",
		"double_chance",
		"bonus_per_milestone",
		"click_milestone_bonus",
	]
	
	var stats_to_save = {}
	
	for k in runtime_stats:
		if k in filter_stats:
			continue
		
		var v = runtime_stats[k]
		stats_to_save[k] = v
	
	stats_to_save["total_playtime"] = total_playtime

	return stats_to_save

func _on_data_loaded(save_stats: Dictionary):	
	var save_stats_duplicate = save_stats.duplicate(true)
	
	for k in save_stats_duplicate:
		var v = save_stats_duplicate.get(k)
		
		runtime_stats[k] = v
