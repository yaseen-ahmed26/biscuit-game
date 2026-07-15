extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var fade: ColorRect = $CanvasLayer/fade
@onready var saving: RichTextLabel = $CanvasLayer/saving
@onready var message_popup: Panel = $CanvasLayer/message_popup

var current_screen: Control

func _ready() -> void:
	current_screen = $CanvasLayer/main_menu
	
	Signals.change_screen.connect(_on_change_screen)
	Signals.data_saved.connect(_on_data_saved)
	Signals.show_message_popup.connect(_on_show_message_popup)
	
func _on_change_screen(to_show: String):
	fade.mouse_filter = MouseFilter.MOUSE_FILTER_STOP
	
	var new_screen = canvas_layer.get_node_or_null(to_show)
	
	if not new_screen:
		print("'%s' scene was not found" % to_show)
		return
		
	var tween_in: Tween = create_tween()
	tween_in.tween_property(fade, "self_modulate:a", 1.0, 0.5)
	await tween_in.finished

	current_screen.visible = false
	new_screen.visible = true
	
	if new_screen.has_method("on_screen_change"):
		new_screen.call("on_screen_change")
	
	current_screen = new_screen
	
	await get_tree().create_timer(1.0).timeout
	
	var tween_out: Tween = create_tween()
	tween_out.tween_property(fade, "self_modulate:a", 0.0, 0.5)
	await tween_out.finished
	
	fade.mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE

func _on_data_saved():
	var tween_in: Tween = create_tween()
	tween_in.tween_property(saving, "modulate:a", 1.0, 0.5)
	
	await get_tree().create_timer(3.0).timeout
	
	var tween_out: Tween = create_tween()
	tween_out.tween_property(saving, "modulate:a", 0.0, 0.5)

func _on_show_message_popup(info_name: String):
	var information = Constants.MESSAGES.get(info_name)
	
	if not information:
		return
	
	$CanvasLayer/message_popup/background/primary.text = information.primary
	$CanvasLayer/message_popup/background/secondary.text = information.secondary
	$CanvasLayer/message_popup/background/proceed_btn.text = information.btn
	$CanvasLayer/message_popup/message_title.text = information.title
	
	var tween_in: Tween = create_tween()
	tween_in.tween_property(message_popup, "modulate:a", 1.0, 0.5)

func _on_proceed_btn_pressed() -> void:
	var tween_out: Tween = create_tween()
	tween_out.tween_property(message_popup, "modulate:a", 0.0, 0.5)
	
	Signals.show_message_proceed.emit()
