extends Control

@onready var stat_increase: RichTextLabel = $stat_increase
@onready var boost_description: RichTextLabel = $boost_description
@onready var boost_name: RichTextLabel = $boost_name
@onready var timer: Timer = $Timer
@onready var time_label: RichTextLabel = $time/label
@onready var activate_btn: Button = $activate_btn

enum State{ACTIVE, COOLDOWN, READY, DISABLED}
var state: State

var boost_data: Dictionary

func _ready() -> void:
	state = State.DISABLED
	
	timer.timeout.connect(_on_timer_ended)

func _process(_delta: float) -> void:
	if not timer.is_stopped():
		var total_secs: int = int(timer.time_left)
		var minutes: int = (total_secs % 3600) / 60
		var seconds: int = total_secs % 60
		
		var time_string = "%02d:%02d" % [minutes, seconds]
		var mode = "[color=red]COOLDOWN" if state == 1 else "[color=green]ACTIVE"
		
		time_label.text = "%s: [color=white]%s" % [mode, time_string]

func set_up_line(data):
	boost_data = data

	boost_name.text = data.get("name")
	boost_description.text = data.get("description")
	stat_increase.text = data.get("change")
			
	self.set_meta("id", data.id)
	self.set_meta("group", data.group)
	self.name = data.id
	
	state = State.COOLDOWN
	
	timer.wait_time = data.get("stats").get("cooldown")
	
	timer.start()

func _start_timer():
	match state:
		0: # active
			timer.start(boost_data.get("stats").get("duration"))
			activate_btn.disabled = true
			activate_btn.text = "Active"
			
			owner.call("update_counter", false)
			
			PlayerManager.apply_boost(boost_data.get("stats").get("effect"), boost_data.get("id"))
		1: # cooldown
			timer.start(boost_data.get("stats").get("cooldown"))
			activate_btn.text = "Not Ready"
			activate_btn.disabled = true

func _on_timer_ended():
	match state:
		0: # active
			state = State.COOLDOWN
			_start_timer()
			
			PlayerManager.boost_ended(boost_data.get("stats").get("effect"),boost_data.get("id"))
		1: # cooldown
			state = State.READY
			time_label.text = "[color=gold]READY"
			activate_btn.text = "Boost"
			activate_btn.disabled = false
			
			owner.call("update_counter", true)

func _on_activate_btn_pressed() -> void:
	if not state == 2: return
	
	state = State.ACTIVE
	_start_timer()
	
