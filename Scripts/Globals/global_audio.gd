extends Node


@onready var pistol_shot: AudioStreamPlayer = %PistolShot
@onready var pistol_mag_eject: AudioStreamPlayer = %PistolMagEject
@onready var pistol_mag_load: AudioStreamPlayer = %PistolMagLoad


func play_sound(audio_player: AudioStreamPlayer, volume: float = 0.0, min_pitch: float = 1.0, max_pitch: float = 1.0) -> void:
	audio_player.volume_db = volume
	var pitch : float = randf_range(min_pitch, max_pitch)
	audio_player.pitch_scale = pitch
	audio_player.play()
