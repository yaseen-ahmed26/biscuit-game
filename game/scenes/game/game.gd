extends Control

@onready var cookie_counter: RichTextLabel = $cookie_counter
@onready var clicker_btn: Button = $clicker_btn

@onready var effect: RichTextLabel = $effect

var runtine_account_connected = false

func _ready() -> void:
	_on_stats_changed(PlayerManager.runtime_stats)
	Signals.stats_changed.connect(_on_stats_changed)
	Signals.account_connected.connect(_on_account_connected)

func _on_clicker_btn_pressed() -> void:
	var details = PlayerManager.cookie_click()
	var effect_colour = Constants.EFFECT_COLOURS.get(details[1])
	var clone: RichTextLabel = effect.duplicate()
	
	self.add_child(clone)
	var starting_position = Vector2(randf_range(100, 1700), 1080)
	var end_position = starting_position - Vector2(0, randf_range(200, 1000))

	clone.text = "+%.1f" % details[0]
	clone.add_theme_color_override("default_color", effect_colour)
	
	var attribute = clone.get_node("attribute")
	attribute.add_theme_color_override("default_color", effect_colour)
	attribute.text = details[1]
	
	clone.position = starting_position
	
	var tween: Tween = create_tween()
	tween.tween_property(clone, "position", end_position, Constants.EFFECT_ENTRY_TIME)
	
	await get_tree().create_timer(Constants.EFFECT_LINGER_TIME).timeout
	
	var tween_fade: Tween = create_tween()
	tween_fade.tween_property(clone, "modulate:a", 0.0, Constants.EFFECT_FADE_TIME)
	
	await tween_fade.finished
	clone.queue_free()
	
func _on_stats_changed(stats):
	cookie_counter.text = "BISCUITS: %.1f" % stats.biscuits

func on_screen_change():
	GameManager.enable_autosave()
	
	if runtine_account_connected:
		await get_tree().create_timer(0.6).timeout
		runtine_account_connected = false
		Signals.show_modal.emit("welcome_bonus")	

func _on_menu_btn_pressed() -> void:
	Signals.change_screen.emit("main_menu")

func _on_account_connected(_player_username):
	_on_stats_changed(PlayerManager.runtime_stats)
	runtine_account_connected = true
