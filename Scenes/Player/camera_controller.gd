extends Node3D
class_name CameraController

@export var mouse_sensitivity : float = 0.1

@onready var bounce_pivot: Node3D = %BouncePivot
@onready var rotation_pivot: Node3D = %RotationPivot
@onready var camera_bob_pivot: Node3D = %CameraBobPivot
@onready var weapon_bob_pivot: Node3D = %WeaponBobPivot
@onready var camera: Camera3D = %Camera3D

var camera_tilt_lower_limit : float = deg_to_rad(-90.0)
var camera_tilt_upper_limit : float = deg_to_rad(90.0)

var _mouse_rotation : Vector3
var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3

var _kickback_tween : Tween
var _recovery_tween : Tween

var _kickback_strength : float

var player : PlayerController

var time_passed: float = 0.0

var bob_enabled: float = false
var bob_speed: float #= 2.0  # Speed of the bobbing motion
var bob_rate: float #= 3.0  # Rate of the bobbing motion
var max_bob_height: float #= 0.1  # Maximum vertical bob distance
var max_bob_width: float #= 0.3  # Maximum horizontal bob distance

func _ready() -> void:
	await owner.ready
	player = get_parent() as PlayerController

func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * mouse_sensitivity
		_tilt_input = -event.relative.y * mouse_sensitivity

func _physics_process(delta: float) -> void:
	_update_camera_bob(delta)
	_update_camera_movement(delta)

func _update_camera_movement(delta: float) -> void:
	## set and clamp horizontal mouse movement
	_mouse_rotation.x += (_tilt_input + _kickback_strength) * delta
	_mouse_rotation.x  = clamp(_mouse_rotation.x, camera_tilt_lower_limit, camera_tilt_upper_limit)
	
	## set vertical mouse movement
	_mouse_rotation.y += (_rotation_input + (_kickback_strength * 0.3) * GlobalFunc.random_negative()) * delta
	
	## apply player mouse rotation
	_player_rotation = Vector3(0.0, _mouse_rotation.y, 0.0)
	
	## apply camera mouse rotation
	_camera_rotation = Vector3(_mouse_rotation.x, 0.0, 0.0)
	
	## apply vertical camera rotation
	rotation_pivot.transform.basis = Basis.from_euler(_camera_rotation)
	rotation_pivot.rotation.z = 0.0
	
	## apply horizontal camera rotation to player body
	player.global_transform.basis = Basis.from_euler(_player_rotation)
	
	## reset before next tick
	_rotation_input = 0.0
	_tilt_input = 0.0


func set_camera_bob(enabled: bool = false, speed: float = 2.5, rate: float = 2.0, width: float = 0.15, height: float = 0.15) -> void:
	bob_enabled = enabled
	bob_speed = speed
	bob_rate = rate
	max_bob_width = width
	max_bob_height = height


func trigger_camera_kickback(_strength: float) -> void:
	_kickback_strength = _strength
	if _kickback_tween: 
		_kickback_tween.stop()
		_recovery_tween.stop()
	_kickback_tween = create_tween()
	_kickback_tween.tween_property(self, '_kickback_strength', 0.0, 0.1).set_ease(Tween.EASE_OUT)
	_kickback_tween.tween_callback(trigger_kickback_recovery.bind(_strength))
func trigger_kickback_recovery(_strength: float) -> void:
	_kickback_strength = -_strength * 0.5
	if _recovery_tween: 
		_recovery_tween.stop()
	_recovery_tween = create_tween()
	_recovery_tween.tween_property(self, '_kickback_strength', 0.0, 0.1).set_ease(Tween.EASE_OUT)


func trigger_camera_jump_bounce(_drop_strength: float = 0.1) -> void:
	var tween : Tween = create_tween()
	_drop_strength = abs(_drop_strength)
	tween.tween_property(bounce_pivot, 'position:y', -_drop_strength, 0.05)
	tween.tween_property(bounce_pivot, 'position:y', 0.0, 0.2)

func _update_camera_bob(delta: float) -> void:
	# Define the minimum reduction factor
	var min_bob_factor: float = 0.0  # Adjust this value to set your desired minimum reduction

	if bob_enabled:
		# Get the viewing angle (assuming camera is a child of the player and its rotation affects the viewing angle)
		var camera_angle : float = rotation_degrees.x
		# Normalize the angle to a factor (e.g., 1 when looking straight, min_bob_factor when looking fully down)
		var bob_factor : float = clamp(1.0 - abs(camera_angle) / 90.0, min_bob_factor, 1.0)

		# Update the internal time
		time_passed += delta * bob_speed

		# Calculate the bobbing positions using the accumulated time for a back-and-forth pattern
		var target_bob_x: float = max_bob_width * sin(time_passed * bob_rate) * bob_factor
		var target_bob_y: float = max_bob_height * pow(sin(time_passed * bob_rate), 2) * bob_factor

		if !GlobalVar.player.weapon_controller.aim_down_sights:
			weapon_bob_pivot.position.x = lerpf(weapon_bob_pivot.position.x, target_bob_x * 0.5, 0.1)
			weapon_bob_pivot.position.y = lerpf(weapon_bob_pivot.position.y, -target_bob_y * 0.5, 0.1)
		else:
			weapon_bob_pivot.position.x = lerpf(weapon_bob_pivot.position.x, 0.0, 0.5)
			weapon_bob_pivot.position.y = lerpf(weapon_bob_pivot.position.y, 0.0, 0.5)

		camera_bob_pivot.position.x = lerpf(camera_bob_pivot.position.x, target_bob_x, 0.1)
		camera_bob_pivot.position.y = lerpf(camera_bob_pivot.position.y, -target_bob_y, 0.1)
			
	else:
		weapon_bob_pivot.position.x = lerpf(weapon_bob_pivot.position.x, 0.0, 0.2)
		weapon_bob_pivot.position.y = lerpf(weapon_bob_pivot.position.y, 0.0, 0.2)
		
		camera_bob_pivot.position.x = lerpf(camera_bob_pivot.position.x, 0.0, 0.2)
		camera_bob_pivot.position.y = lerpf(camera_bob_pivot.position.y, 0.0, 0.2)
