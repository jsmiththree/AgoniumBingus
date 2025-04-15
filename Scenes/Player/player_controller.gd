extends CharacterBody3D
class_name PlayerController

@export var gravity : float = 25.0
@export var jump_velocity : float = 8.0

@onready var camera: Camera3D = %Camera3D
@onready var camera_controller: Node3D = %CameraController
@onready var animation: AnimationPlayer = %AnimationPlayer

var current_state : String
var move_speed : float #= 4.0
var acceleration : float #= 0.2
var deceleration : float #= 0.4

var _has_jumped : bool = false
var _is_falling : bool = false
var _is_crouching : bool = false

func _ready() -> void:
	## set player camera fov
	camera.fov = GlobalVar.first_person_fov

func _physics_process(_delta: float) -> void:
	if !is_on_floor() && velocity.y < 0.0: _is_falling = true
	
	if is_on_floor() && _is_falling:
		camera_controller.trigger_camera_jump_bounce()
		_has_jumped = false
		_is_falling = false


func update_gravity(delta: float) -> void:
	## apply gravity
	if !is_on_floor(): velocity.y -= gravity * delta


func update_jump() -> void:
	## apply jump
	if Input.is_action_just_pressed('input_action_jump') && is_on_floor():
		velocity.y = jump_velocity
		_has_jumped = true
		
	## cut jump short if the button is released
	if Input.is_action_just_released('input_action_jump') && _has_jumped && velocity.y > 0.0:
		velocity.y = velocity.y * 0.5

func update_crouch(enable_crouch: bool = true) -> void:
	var crouch_animation_speed : float = 3.0
	if Input.is_action_pressed('input_action_crouch') && is_on_floor() && enable_crouch:
		if animation.current_animation != 'crouch' && !_is_crouching:
			animation.play('crouch', -1, crouch_animation_speed)
			_is_crouching = true
	else:
		if animation.current_animation != 'uncrouch' && _is_crouching:
			animation.play('crouch', -1, -crouch_animation_speed, true)
			_is_crouching = false

func set_movement_properties(_move_speed: float, _acceleration: float, _deceleration: float) -> void:
	move_speed = _move_speed
	acceleration = _acceleration
	deceleration = _deceleration
	
func update_movement(enable_control: bool = true) -> void:
	## get player movement input
	var input_direction := Input.get_vector('input_move_left', 'input_move_right', 'input_move_forward', 'input_move_backward')
	
	## calculate movement direction
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	## set player velocity
	if direction && enable_control:
		var _movement_speed : float = move_speed
		if _is_crouching: _movement_speed = move_speed * 0.5
		velocity.x = lerpf(velocity.x, direction.x * _movement_speed, acceleration)
		velocity.z = lerpf(velocity.z, direction.z * _movement_speed, acceleration)
	
	## slow to a stop if no movement input
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)
		
	move_and_slide()
