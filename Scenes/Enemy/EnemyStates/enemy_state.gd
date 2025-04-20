extends State
class_name EnemyState

var enemy : EnemyController

func _ready() -> void:
	await owner.ready
	enemy = get_parent().get_parent() as EnemyController

#func enter(_previous_state) -> void:
	#pass
	
#func exit() -> void:
	#pass
	#
#func update(_delta: float) -> void:
	#pass
	#
#func physics_update(_delta: float) -> void:
	#pass
