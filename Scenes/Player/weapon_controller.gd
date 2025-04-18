extends Node3D
class_name WeaponController

@export var weapon : WeaponModule

@onready var weapon_rotation_pivot: Node3D = %WeaponRotationPivot
@onready var weapon_animation: AnimationPlayer = %WeaponAnimation

var aim_down_sights : bool = false

func _process(_delta: float) -> void:
	var max_distance = 0.1  # Max distance weapon can be from origin
	#if aim_down_sights: max_distance = 0.0
	
	# Update weapon position
	var pos_weight : float = 0.5
	if aim_down_sights: pos_weight = 0.95
	weapon_rotation_pivot.global_position = lerp(weapon_rotation_pivot.global_position, GlobalVar.player.camera.global_position, pos_weight)

	# Interpolate rotation
	var rot_y_weight : float = 0.7
	if aim_down_sights: rot_y_weight = 0.95
	weapon_rotation_pivot.rotation.y = lerp_angle(weapon_rotation_pivot.rotation.y, GlobalVar.player.rotation.y, rot_y_weight)
	
	var rot_x_weight : float = 0.5
	if aim_down_sights: rot_x_weight = 0.95
	weapon_rotation_pivot.rotation.x = lerp_angle(weapon_rotation_pivot.rotation.x, GlobalVar.player.camera_controller.rotation_pivot.rotation.x, rot_x_weight)

	# Enforce maximum distance
	var distance_vector = weapon_rotation_pivot.global_position - GlobalVar.player.camera.global_position
	if distance_vector.length() > max_distance:
		weapon_rotation_pivot.global_position = GlobalVar.player.camera.global_position + distance_vector.normalized() * max_distance

func _physics_process(_delta: float) -> void:
	
	## TODO change where/how weapon input is handled
	if Input.is_action_just_pressed('input_left_mouse'):
		if weapon.animation.is_playing(): return
		if weapon_animation.is_playing(): return
		weapon.fire_weapon()
		
	if Input.is_action_just_pressed('input_action_reload'):
		if weapon.animation.is_playing(): return
		if weapon.loaded_ammo == weapon.magazine_size: return
		#if weapon_animation.is_playing(): return
		if aim_down_sights:
			weapon_animation.play('aim_down_sights_reload', -1, -3.0, true)
			aim_down_sights = false
		else: _reload_weapon()
	
	if Input.is_action_pressed('input_right_mouse'):
		if weapon.animation.is_playing(): return
		if !weapon_animation.is_playing() && !aim_down_sights:
			aim_down_sights = true
			weapon_animation.play('aim_down_sights', -1, 3.0)
			
	if !Input.is_action_pressed('input_right_mouse'):
		if weapon.animation.is_playing(): return
		if !weapon_animation.is_playing() && aim_down_sights:
			weapon_animation.play('aim_down_sights', -1, -2.0, true)
			aim_down_sights = false

func _reload_weapon() -> void:
	weapon.reload_weapon()
