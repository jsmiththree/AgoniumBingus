extends Control
class_name PlayerUIController


@onready var ammo_counter: Label = %AmmoCounter
@onready var center_dot: CenterContainer = %CenterDot


func _process(_delta: float) -> void:
	center_dot.visible = true
	if GlobalVar.player.weapon_controller.aim_down_sights:
		center_dot.visible = false

func set_ammo_count(_loaded_count: int, _mag_size: int, _total_count: int) -> void:
	var _loaded : String = str(_loaded_count)
	var _mag : String = str(_mag_size)
	var _total : String = str(_total_count)
	
	if _loaded_count < 10: _loaded = '0%s' % _loaded
	if _mag_size < 10: _mag = '0%s' % _mag
	if _total_count < 100: _total = '0%s' % _total
	if _total_count < 10: _total = '0%s' % _total
	
	ammo_counter.text = '%s/%s | %s' % [_loaded, _mag, _total]
