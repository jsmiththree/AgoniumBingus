extends CharacterBody3D
class_name PlayerController

@export var gravity : float = 20.0
@export var jump_velocity : float = 8.0
@export var move_speed : float = 5.0

@onready var camera: Camera3D = %Camera3D
@onready var camera_controller: Node3D = %CameraController

var current_state : String
var _has_jumped : bool = false

func _ready() -> void:
	await owner.ready
	
	## set player camera fov
	camera.fov = GlobalVar.first_person_fov

func _physics_process(_delta: float) -> void:
	if is_on_floor():
		_has_jumped = false

func update_gravity(delta: float) -> void:
	## apply gravity
	if !is_on_floor(): velocity.y -= gravity * delta

func update_movement(_delta: float, enable_jump: bool = true, enable_movement: bool = true) -> void:

	## jump input
	if enable_jump:
		if Input.is_action_just_pressed('input_action_jump') && is_on_floor():
			velocity.y = jump_velocity
			_has_jumped = true
		if Input.is_action_just_released('input_action_jump') && _has_jumped && velocity.y > 0.0:
			velocity.y = velocity.y * 0.5

	var input_direction := Input.get_vector('input_move_left', 'input_move_right', 'input_move_forward', 'input_move_backward')
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	if direction && enable_movement:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
		
	move_and_slide()
