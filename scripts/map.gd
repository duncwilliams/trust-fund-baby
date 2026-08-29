extends Node2D

signal arrived_at_second_floor()

@export var money: PackedScene
var first_money_wave_amount: int = 50
var second_money_wave_amount: int = 100
var first_wave_delay: float = 0.15
var second_wave_delay: float = 0.5

func disable_invisible_walls() -> void:
	$InvisibleWallsTML.enabled = false


func start_spawning_money() -> void:
	for i in first_money_wave_amount:
		spawn_money()
		await get_tree().create_timer(first_wave_delay).timeout
	for i in second_money_wave_amount:
		spawn_money()
		await get_tree().create_timer(second_wave_delay).timeout

func spawn_money() -> void:
	var instance = money.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.global_position = Vector2(randf_range($CashSpawnLeftMarker.position.x, $CashSpawnRightMarker.position.x), randf_range($CashSpawnLeftMarker.position.y, $CashSpawnRightMarker.position.y))

func _on_second_floor_trigger_area_entered(area: Area2D) -> void:
	if area.is_in_group("baby"):
		$SecondFloorTrigger.set_deferred("monitorable", false)
		$SecondFloorTrigger.set_deferred("monitoring", false)
		await get_tree().create_timer(1.0).timeout
		%'2FHiddenFloorTML'.visible = true
		arrived_at_second_floor.emit()
