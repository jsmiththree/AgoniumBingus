extends Node3D
class_name CameraController

@export var mouse_sensitivity : float = 0.1

var camera_tilt_lower_limit : float = deg_to_rad(-90.0)
var camera_tilt_upper_limit : float = deg_to_rad(90.0)

var _mouse_rotation : Vector3
var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3

var player : PlayerController

func _ready() -> void:
	await owner.ready
	player = get_parent() as PlayerController

func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * mouse_sensitivity
		_tilt_input = -event.relative.y * mouse_sensitivity

func _physics_process(delta: float) -> void:
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x  = clamp(_mouse_rotation.x, camera_tilt_lower_limit, camera_tilt_upper_limit)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0, _mouse_rotation.y, 0.0)
	_camera_rotation = Vector3(_mouse_rotation.x, 0.0, 0.0)
	
	## apply vertical camera rotation
	transform.basis = Basis.from_euler(_camera_rotation)
	rotation.z = 0.0
	
	## apply horizontal camera rotation to player body
	player.global_transform.basis = Basis.from_euler(_player_rotation)
	
	_rotation_input = 0.0
	_tilt_input = 0.0
