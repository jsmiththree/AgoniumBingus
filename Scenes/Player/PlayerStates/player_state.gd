extends State
class_name PlayerState

var player : PlayerController
var camera_controller : CameraController

func _ready() -> void:
	await owner.ready
	player = get_parent().get_parent() as PlayerController
	camera_controller = player.camera_controller

#func enter(_previous_state) -> void:
	#pass
	
#func exit() -> void:
	#pass
	#
#func update(_delta: float) -> void:
	#pass
	#
#func physics_update(_delta: float) -> void:
	#pass
