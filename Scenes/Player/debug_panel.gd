extends CanvasLayer
class_name DebugPanel

@onready var state_label: Label = %StateLabel

var player : PlayerController

func _ready() -> void:
	visible = false
	
	await owner.ready
	player = get_parent() as PlayerController

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed('input_debug_toggle'): visible = !visible
	
	state_label.text = 'Current State: %s' % player.current_state
