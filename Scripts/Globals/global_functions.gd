extends Node

@export var period = 0.1
@export var magnitude = 0.05

func random_negative() -> int:
	var _coin_flip : int = randi_range(0, 1)
	if _coin_flip == 0: return -1
	return 1

func camera_shake(camera: Camera3D):
	var initial_transform = camera.transform 
	var elapsed_time = 0.0

	while elapsed_time < period:
		var offset = Vector3(
			randf_range(-magnitude, magnitude),
			randf_range(-magnitude, magnitude),
			0.0
		)

		camera.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame

	camera.transform = initial_transform
