extends Node3D
class_name WeaponController

@export var weapon : WeaponModule
@export var shot_spark_particle : PackedScene

@onready var weapon_rotation_pivot: Node3D = %WeaponRotationPivot
@onready var weapon_animation: AnimationPlayer = %WeaponAnimation
@onready var weapon_aim_cast: RayCast3D = %WeaponAimCast

var aim_down_sights : bool = false

func _process(_delta: float) -> void:
	var max_distance = 0.1  # Max distance weapon can be from origin
	#if aim_down_sights: max_distance = 0.0
	
	# Update weapon position
	var pos_weight : float = 0.3
	if aim_down_sights: pos_weight = 0.95
	weapon_rotation_pivot.global_position = lerp(weapon_rotation_pivot.global_position, GlobalVar.player.camera.global_position, pos_weight)

	# Interpolate rotation
	var rot_y_weight : float = 0.5
	if aim_down_sights: rot_y_weight = 0.95
	weapon_rotation_pivot.rotation.y = lerp_angle(weapon_rotation_pivot.rotation.y, GlobalVar.player.rotation.y, rot_y_weight)
	
	var rot_x_weight : float = 0.3
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
			weapon_animation.play('aim_down_sights_reload', -1, -4.0, true)
			aim_down_sights = false
		else: _reload_weapon()
	
	if Input.is_action_pressed('input_right_mouse'):
		if weapon.animation.is_playing(): return
		if !weapon_animation.is_playing() && !aim_down_sights:
			aim_down_sights = true
			weapon_animation.play('aim_down_sights', -1, 4.0)
			
	if !Input.is_action_pressed('input_right_mouse'):
		if weapon.animation.is_playing(): return
		if !weapon_animation.is_playing() && aim_down_sights:
			weapon_animation.play('aim_down_sights', -1, -3.0, true)
			aim_down_sights = false

func _reload_weapon() -> void:
	weapon.reload_weapon()


func _on_weapon_module_weapon_fired() -> void:
	if weapon_aim_cast.is_colliding():
		var sparks : GPUParticles3D = shot_spark_particle.instantiate()
		get_tree().get_root().add_child(sparks)
		sparks.global_position = weapon_aim_cast.get_collision_point()
		sparks.emitting = true
		sparks.shot_impact.emitting = true
