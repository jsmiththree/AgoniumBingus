extends GPUParticles3D

@onready var shot_impact: GPUParticles3D = $ShotImpact


func _on_finished() -> void:
	queue_free()
