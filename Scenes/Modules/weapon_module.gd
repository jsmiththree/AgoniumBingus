extends Node3D
class_name WeaponModule

@export var muzzle_flash_particle : PackedScene

@onready var animation : AnimationPlayer = %AnimationPlayer
@onready var muzzle_flash_origin: Marker3D = %MuzzleFlashOrigin

var magazine_size : int = 12
var loaded_ammo : int = 12
var total_ammo_pool : int = 36

func _ready() -> void:
	await owner.ready
	GlobalVar.player.ui_controller.set_ammo_count(loaded_ammo, magazine_size, total_ammo_pool)

func fire_weapon() -> void:
	if animation.is_playing(): return
	
	if loaded_ammo > 0:
		animation.play('weapon_fire', -1, 6.0)
		
		GlobalFunc.camera_shake(GlobalVar.player.camera)
		
		GlobalVar.player.camera_controller.trigger_camera_kickback()
		
		var muzzle_flash : GPUParticles3D = muzzle_flash_particle.instantiate()
		muzzle_flash_origin.add_child(muzzle_flash)
		muzzle_flash.emitting = true
		
		loaded_ammo -= 1
		
		GlobalVar.player.ui_controller.set_ammo_count(loaded_ammo, magazine_size, total_ammo_pool)
	
