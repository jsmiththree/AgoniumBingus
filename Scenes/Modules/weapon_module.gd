extends Node3D
class_name WeaponModule

@export var muzzle_flash_particle : PackedScene

@onready var animation : AnimationPlayer = %AnimationPlayer
@onready var muzzle_flash_origin: Marker3D = %MuzzleFlashOrigin


func fire_weapon() -> void:
	if animation.is_playing(): return
	
	animation.play('weapon_fire', -1, 6.0)
	
	GlobalFunc.camera_shake(GlobalVar.player.camera)
	
	var muzzle_flash : GPUParticles3D = muzzle_flash_particle.instantiate()
	muzzle_flash_origin.add_child(muzzle_flash)
	muzzle_flash.emitting = true
