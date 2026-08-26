extends Node2D

@export var second_floor_enemy_scene: PackedScene


func _ready() -> void:
	$Enemy.disable()
	$Enemy.disable_mode


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func spawn_second_floor_enemy() -> void:
	$Enemy.enable()
	
	# commenting this section as I want to have enemy already in scene rather than spawning
	#var enemy = second_floor_enemy_scene.instantiate()
	#get_tree().current_scene.add_child(enemy)
	#enemy.global_position = %SecondFloorEnemySpawnPoint.global_position


func _on_baby_milk_amount_changed(new_milk_amount: int) -> void:
	$Hud.update_milk_amount(new_milk_amount)


func _on_map_arrived_at_second_floor() -> void:
	$Baby.empty_bottle()
	await get_tree().create_timer(2.0).timeout
	$Hud.play_second_floor_dialogue()
	$Baby.refill_bottle()


func _on_hud_dialogue_finished(dialogue_title: String) -> void:
	if dialogue_title == "second floor":
		spawn_second_floor_enemy()
		$Map.disable_invisible_walls()
		


func _on_enemy_health_changed(new_health: int) -> void:
	$Hud.update_boss_health_bar(new_health)


func _on_baby_took_damage(remaining_health: float) -> void:
	$Hud.update_baby_health_amount(remaining_health)
