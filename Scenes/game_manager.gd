extends Node3D
class_name GameManager

## initial scene to "boot" into on runtime
@export var initial_scene : PackedScene

func _input(event: InputEvent) -> void:
	## quit game with ESC key, only if mouse is not captured, otherwise free the mouse
	if event.is_action_pressed('input_action_exit'):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			get_tree().quit()
		else: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	## capture mouse when game window is clicked on with lmb
	if event.is_action_pressed('input_left_mouse'):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready() -> void:
	## set global game manager reference
	GlobalVar.game_manager = self
	
	## instantiate initial game scene
	var scene : Node3D = initial_scene.instantiate()
	add_child(scene)
