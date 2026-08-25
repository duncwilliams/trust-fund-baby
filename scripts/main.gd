extends Node2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func _on_map_arrived_at_second_floor() -> void:
	$Baby.empty_bottle()
	await get_tree().create_timer(2.0).timeout
	$Hud.play_second_floor_dialogue()
	$Baby.refill_bottle()
