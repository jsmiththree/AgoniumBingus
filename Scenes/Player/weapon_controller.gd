extends Node3D
class_name WeaponController

@export var weapon : WeaponModule

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed('input_left_mouse'):
		weapon.fire_weapon()
		
	if Input.is_action_just_pressed('input_action_reload'):
		weapon.reload_weapon()
