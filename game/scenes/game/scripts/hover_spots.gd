extends Control

@onready var buttons: Array[Button] = [
	$multiplier_two,
	$multiplier_three,
	$multiplier_four
]

var cookies_accumulated = 0
var is_hovering = false

func _ready():	
	for btn in buttons:
		_move_button_randomly(btn)
		
		btn.mouse_entered.connect(_on_button_hover_enter.bind(btn))
		btn.mouse_exited.connect(_on_button_hover_exit.bind(btn))

func _move_button_randomly(btn: Button):
	var wait_time = randf_range(0.5, 2.5)
	await get_tree().create_timer(wait_time).timeout
	
	var max_x = size.x - btn.size.x
	var max_y = size.y - btn.size.y
	
	var target_position = Vector2(
		randf_range(0, max_x),
		randf_range(0, max_y)
	)
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(btn, "position", target_position, 1.2).set_trans(Tween.TRANS_SINE)
	
	tween.finished.connect(_move_button_randomly.bind(btn))

func _on_button_hover_enter(btn: Button):
	is_hovering = true
	$"../RichTextLabel".text = "HOVERING"

func _on_button_hover_exit(btn: Button):
	is_hovering = false
	
	if not is_hovering:
		$"../RichTextLabel".text = "NOT HOVERING"
