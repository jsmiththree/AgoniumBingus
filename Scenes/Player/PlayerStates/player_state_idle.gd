extends PlayerState


#func enter(_previous_state) -> void:
	#pass
	#
#func exit() -> void:
	#pass
	#
#func update(_delta: float) -> void:
	#pass
	#
func physics_update(delta: float) -> void:
	if is_instance_valid(player):
		player.update_gravity(delta)
		player.update_movement(delta)
