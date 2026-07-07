extends Control

# websocket stuff needs to be moved here

func _ready() -> void:
	Signals.display_code.connect(_display_code)

func _display_code(code: String):
	$code.text = "[color=green]%s" % code
