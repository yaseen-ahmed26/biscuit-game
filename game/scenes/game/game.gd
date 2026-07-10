extends Control

@onready var cookie_counter: RichTextLabel = $cookie_counter
@onready var clicker_btn: Button = $clicker_btn

func _ready() -> void:
	Signals.stats_changed.connect(_on_stats_changed)

func _on_clicker_btn_pressed() -> void:
	PlayerManager.click_cookie()

func _on_stats_changed(stats):
	cookie_counter.text = "COOKIES: %.1f" % stats.biscuits
