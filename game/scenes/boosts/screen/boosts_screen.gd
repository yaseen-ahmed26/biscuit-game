extends Control

@onready var holder: Control = $holder
@onready var counter: RichTextLabel = $counter

var open: bool = false
var boost_data: Array

var boosts_ready: int = 0

func _ready() -> void:
	boost_data = GameManager.read_json(Constants.BOOSTS_FILE_PATH)
	
	_set_boost_lines()

func _set_boost_lines():
	var total_boosts = boost_data.size()
	
	for i in total_boosts:
		var boost = boost_data[i]
		var line = holder.get_node_or_null(str(i))
		
		if line:
			line.call("set_up_line", boost)
		else:
			push_warning("Not enough upgrade lines")
	
	counter.text = "%d/%d" % [boosts_ready, total_boosts]

func _on_open_btn_pressed() -> void:
	var use_position: Vector2
	
	if open:
		use_position = Constants.BOOSTS_HIDDEN_POSITION
		open = false
	else:
		use_position = Constants.BOOSTS_OPEN_POSITION
		open = true
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", use_position, 0.3)

func update_counter(is_ready: bool):
	if is_ready:
		boosts_ready += 1
	else:
		boosts_ready -= 1
	
	counter.text = "%d/%d" % [boosts_ready, boost_data.size()]
