extends Node2D

signal arrived_at_second_floor()


func disable_invisible_walls() -> void:
	$InvisibleWallsTML.enabled = false

func _on_second_floor_trigger_area_entered(area: Area2D) -> void:
	$SecondFloorTrigger.set_deferred("monitorable", false)
	$SecondFloorTrigger.set_deferred("monitoring", false)
	await get_tree().create_timer(1.0).timeout
	%'2FHiddenFloorTML'.visible = true
	arrived_at_second_floor.emit()
