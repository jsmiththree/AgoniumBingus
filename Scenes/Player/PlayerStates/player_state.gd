extends State
class_name PlayerState

var player : PlayerController

func _ready() -> void:
	await owner.ready
	player = get_parent().get_parent() as PlayerController
	player.current_state = self.name

#func enter(_previous_state) -> void:
	#pass
	#
#func exit() -> void:
	#pass
	#
#func update(_delta: float) -> void:
	#pass
	#
#func physics_update(_delta: float) -> void:
	#pass
