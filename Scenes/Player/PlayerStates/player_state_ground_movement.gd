extends PlayerState
class_name PlayerStateGroundMovement

var walk_speed : float = 3.0
var walk_accel : float = 0.2
var walk_decel : float = 0.4

var run_speed : float = 5.0
var run_accel : float = 0.2
var run_decel : float = 0.5

func enter(_previous_state) -> void:
	player.current_state = self.name
	
#func exit() -> void:
	#pass
	
func update(_delta: float) -> void:
	if abs(player.velocity.x) + abs(player.velocity.z) == 0.0:
		transition.emit('Idle')
	else:
		if Input.is_action_pressed('input_action_sprint'):
			player.set_movement_properties(run_speed, run_accel, run_decel)
			camera_controller.set_camera_bob(true, 3.0, 3.5, 0.2, 0.2)
		else:
			camera_controller.set_camera_bob(true, 2.5, 2.0, 0.1, 0.15)
			player.set_movement_properties(walk_speed, walk_accel, walk_decel)
	
func physics_update(delta: float) -> void:
	player.update_gravity(delta)
	player.update_jump()
	player.update_crouch()
	player.update_movement()
