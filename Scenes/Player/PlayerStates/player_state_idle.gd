extends PlayerState
class_name PlayerStateIdle

var idle_speed : float = 1.0
var idle_accel : float = 0.1
var idle_decel : float = 0.4

func enter(_previous_state) -> void:
	player.current_state = self.name
	player.set_movement_properties(idle_speed, idle_accel, idle_decel)
	camera_controller.set_camera_bob(false)
	
#func exit() -> void:
	#pass
	#
func update(_delta: float) -> void:
	if abs(player.velocity.x) + abs(player.velocity.z) > 0.0:
		if player.is_on_floor(): transition.emit('GroundMovement')
		#else: transition.emit('AirMovement')
	
func physics_update(delta: float) -> void:
	player.update_gravity(delta)
	player.update_jump()
	player.update_crouch()
	player.update_movement()
