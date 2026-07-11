extends Control

var on_screen: bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if on_screen:
		var formatted: String = GameManager.get_formatted_time()
		$total_playtime.text = "Total Playtime: %s" % formatted

func on_screen_change():
	on_screen = true

func _on_return_btn_pressed() -> void:
	on_screen = false
	
	Signals.change_screen.emit("main_menu")
