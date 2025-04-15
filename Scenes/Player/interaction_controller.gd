extends RayCast3D
class_name InteractionController

@export_range(0.0, 10.0, 1.0) var interaction_range : float = 2.0

@onready var prompt_label: Label = %PromptLabel


func _process(_delta: float) -> void:
	target_position.z = -interaction_range
	
func _physics_process(_delta: float) -> void:
	prompt_label.visible = false
	if is_colliding():
		var interaction : InteractPointController = get_collider()
		prompt_label.text = interaction.get_prompt_message()
		if Input.is_action_just_pressed('input_action_interact'):
			interaction.trigger_interaction()
		prompt_label.visible = true
