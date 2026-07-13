extends Node

var stats: Dictionary

var additonal_stats: Dictionary = {
	"per_click": 1.0,
}

func _ready() -> void:
	Signals.data_loaded.connect(_on_data_loaded)

func apply_effect(effect: Dictionary):	
	if not stats[effect.target]:
		print("'%s' stat not found" % effect.target)
		Signals.stats_changed.emit(stats)
		return
	
	match effect.type:
		"add": stats[effect.target] += effect.value
		"subtract": stats[effect.target] -= effect.value
		"multiply": stats[effect.target] *= effect.value
		"divide": stats[effect.target] /= effect.value
	
	Signals.stats_changed.emit(stats)

func can_purchase(target: float) -> bool:
	if stats.get("biscuits") >= target:
		stats["biscuits"] -= target
		return true
		
	return false

func bought_upgrade(upgrade_id: String, level: int):
	stats["bought_upgrades"][upgrade_id] = level

func click_cookie():
	stats["total_clicks"] += 1
	
	var amount = stats["per_click"]
	
	stats["biscuits"] += amount
	stats["total_biscuits"] += amount
	
	Signals.stats_changed.emit(stats)

func get_data_to_save():
	var total_playtime: float = GameManager.get_time_played()
	
	stats["total_playtime"] = total_playtime
	
	for k in stats:
		if additonal_stats.has(k):
			stats.erase(k)
	
	return stats

func _on_data_loaded(save_stats: Dictionary):
	stats = save_stats
		
	stats.erase("total_playtime")
	stats.merge(additonal_stats)
