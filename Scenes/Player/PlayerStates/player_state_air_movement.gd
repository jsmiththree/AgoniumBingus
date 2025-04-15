extends PlayerState
class_name PlayerStateAirMovement



func enter(_previous_state) -> void:
	player.current_state = self.name
	camera_controller.set_camera_bob(false)
	
#func exit() -> void:
	#pass
	
func update(_delta: float) -> void:
	if abs(player.velocity.x) + abs(player.velocity.z) == 0.0:
		transition.emit('Idle')
	else:
		if player.is_on_floor():
			transition.emit('GroundMovement')
	
func physics_update(delta: float) -> void:
	player.update_gravity(delta)
	player.update_jump()
	player.update_crouch(false)
	player.update_movement()
