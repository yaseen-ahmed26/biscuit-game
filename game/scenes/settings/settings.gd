extends Control

var on_screen: bool = false

func _ready() -> void:
	for btn in $VBoxContainer.get_children():
		_set_up_btn(btn)

func _process(_delta: float) -> void:
	if on_screen:
		var formatted: String = GameManager.get_formatted_time()
		$total_playtime.text = "Total Playtime: %s" % formatted

func _set_up_btn(btn: Button):
	btn.pressed.connect(_on_setting_btn_clicked.bind(btn))
	
	if btn.get_meta("action") != SaveManager.action:
		btn.visible = false
	else:
		btn.visible = true
		
func _on_setting_btn_clicked(btn: Button):
	match btn.name:
		"reset_data": SaveManager.reset_data()
		"unlink_account": pass
		"migrate_data": pass

func on_screen_change():
	on_screen = true

func _on_return_btn_pressed() -> void:
	on_screen = false
	
	Signals.change_screen.emit("main_menu")
