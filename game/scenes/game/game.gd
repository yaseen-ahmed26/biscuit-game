extends Control

@onready var cookie_counter: RichTextLabel = $cookie_counter
@onready var clicker_btn: Button = $clicker_btn

func _ready() -> void:
	Signals.stats_changed.connect(_on_stats_changed)

func _on_clicker_btn_pressed() -> void:
	PlayerManager.click_cookie()
	
	var clone: RichTextLabel = $effect.duplicate()
	
	self.add_child(clone)
	var starting_position = Vector2(randf_range(100, 1700), 1080)
	var end_position = starting_position - Vector2(0, randf_range(200, 1000))
	
	clone.position = starting_position
	
	var tween: Tween = create_tween()
	tween.tween_property(clone, "position", end_position, 0.4)
	
	await get_tree().create_timer(0.5).timeout
	
	var tween_fade: Tween = create_tween()
	tween_fade.tween_property(clone, "modulate:a", 0.0, 0.5)
	
	await tween_fade.finished
	clone.queue_free()
	
func _on_stats_changed(stats):
	cookie_counter.text = "COOKIES: %.1f" % stats.biscuits
	$effect.text = "+%d" % stats.per_click

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
