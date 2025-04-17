extends Node3D
class_name WeaponModule

@export var muzzle_flash_particle : PackedScene

@onready var animation : AnimationPlayer = %AnimationPlayer
@onready var muzzle_flash_origin: Marker3D = %MuzzleFlashOrigin

var magazine_size : int = 12
var loaded_ammo : int = 12
var total_ammo_pool : int = 999

func _ready() -> void:
	await owner.ready
	GlobalVar.player.ui_controller.set_ammo_count(loaded_ammo, magazine_size, total_ammo_pool)

func fire_weapon() -> void:
	if animation.is_playing(): return
	
	if loaded_ammo > 0:
		animation.play('fire', -1, 5.0)
		
		GlobalFunc.camera_shake(GlobalVar.player.camera)
		
		GlobalVar.player.camera_controller.trigger_camera_kickback()
		
		var muzzle_flash : GPUParticles3D = muzzle_flash_particle.instantiate()
		muzzle_flash_origin.add_child(muzzle_flash)
		muzzle_flash.emitting = true
		
		loaded_ammo -= 1
		
		GlobalVar.player.ui_controller.set_ammo_count(loaded_ammo, magazine_size, total_ammo_pool)
	

func reload_weapon() -> void:
	if animation.is_playing(): return
	
	if loaded_ammo < magazine_size && total_ammo_pool > 0:
		animation.play('reload', -1, 2.0)
		

func reload_ammo_count() -> void:
	if total_ammo_pool >= magazine_size:
		var ammo_spent : int = magazine_size - loaded_ammo
		total_ammo_pool -= ammo_spent
		
		loaded_ammo = magazine_size
	else: 
		loaded_ammo = total_ammo_pool
		total_ammo_pool = 0
		
	GlobalVar.player.ui_controller.set_ammo_count(loaded_ammo, magazine_size, total_ammo_pool)


func play_pistol_shot() -> void:
	GlobalAudio.play_sound(GlobalAudio.pistol_shot, -10.0, 1.0, 1.3)
func play_eject_mag() -> void:
	GlobalAudio.play_sound(GlobalAudio.pistol_mag_eject, -10.0, 0.9, 1.1)
func play_load_mag() -> void:
	GlobalAudio.play_sound(GlobalAudio.pistol_mag_load, -10.0, 0.9, 1.1)
