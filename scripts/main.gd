extends Node2D

@export var second_floor_enemy_scene: PackedScene


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func spawn_second_floor_enemy() -> void:
	var enemy = second_floor_enemy_scene.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = %SecondFloorEnemySpawnPoint.global_position


func _on_map_arrived_at_second_floor() -> void:
	$Baby.empty_bottle()
	await get_tree().create_timer(2.0).timeout
	$Hud.play_second_floor_dialogue()
	$Baby.refill_bottle()


func _on_hud_dialogue_finished(dialogue_title: String) -> void:
	if dialogue_title == "second floor":
		spawn_second_floor_enemy()
