extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	Signals.change_screen.connect(_on_change_screen)
	
func _on_change_screen(old_screen: String, new_screen: String):
	var old_scene = canvas_layer.get_node_or_null(old_screen)
	var new_scene = canvas_layer.get_node_or_null(new_screen)
	
	if not old_scene or not new_scene:
		print("scenes not found")
		return
		
	old_scene.visible = false
	new_scene.visible = true
