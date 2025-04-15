extends Node3D

@onready var animation : AnimationPlayer = %AnimationPlayer
@onready var interact_point_controller: InteractPointController = %InteractPointController

var _lever_toggled_on : bool = false

func _ready() -> void:
	_update_toggle_state()

func _update_toggle_state() -> void:
	if _lever_toggled_on: 
		animation.play('lever_switch_on', -1, 2.0)
		interact_point_controller.set_prompt_message(0)
	else: 
		animation.play('lever_switch_off', -1, 2.0)
		interact_point_controller.set_prompt_message(1)

func _on_interact_point_controller_interaction_triggered() -> void:
	if !animation.is_playing():
		_lever_toggled_on = !_lever_toggled_on
		_update_toggle_state()
