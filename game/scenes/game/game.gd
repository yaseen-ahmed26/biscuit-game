extends Control

@onready var cookie_counter: RichTextLabel = $cookie_counter
@onready var clicker_btn: Button = $clicker_btn

var cookies: float = 0.0

func _ready() -> void:
	pass

func _on_clicker_btn_pressed() -> void:
	cookies += 1
	cookie_counter.text = "COOKIES: %.1f" % cookies
