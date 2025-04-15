extends Area3D
class_name InteractPointController

signal interaction_triggered

@export var prompt_messages : Array[String]

var _current_prompt_message : String

func set_prompt_message(_index: int = 0) -> void:
	_current_prompt_message = '%s [E]' % prompt_messages[_index]
	
func get_prompt_message() -> String:
	return _current_prompt_message

func trigger_interaction() -> void:
	emit_signal('interaction_triggered')
