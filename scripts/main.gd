extends Node2D

@export var second_floor_enemy_scene: PackedScene
var enemy_defeat_camera_speed: float = 3.0

func _ready() -> void:
	$Enemy.disable()
	$Hud/FullscreenMessageControl.visible = false
	if not GameState.intro_played:
		await $Hud.play_fullscreen_intro_message()
		$Hud.play_intro_dialogue()
		$Baby/AnimatedSprite2D.flip_h = true


func _process(_delta: float) -> void:
	if GameState.intro_played and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func move_camera_to_position(target: Node2D, camera_speed: float) -> void:
	call_deferred("$Baby.process_mode", "Node.PROCESS_MODE_DISABLED")
	call_deferred("$Enemy.process_mode", "Node.PROCESS_MODE_DISABLED")
	var tween := create_tween()
	tween.tween_property($Baby/Camera2D, "global_position", target.global_position, camera_speed)
	await tween.finished
	call_deferred("$Baby.process_mode", "Node.PROCESS_MODE_INHERIT")


func victory_sequence() -> void:
	$MusicPlayer/BossMusic.stop()
	await move_camera_to_position($Enemy, enemy_defeat_camera_speed)
	$Hud/DialogueController.play_victory_dialogue()


func defeat_sequence() -> void:
	$Hud/DialogueController.play_defeat_dialogue()

func _on_baby_milk_amount_changed(new_milk_amount: int) -> void:
	$Hud.update_milk_amount(new_milk_amount)


func _on_map_arrived_at_second_floor() -> void:
	$Baby.empty_bottle()
	$MusicPlayer/BackgroundMusic.stop()
	await get_tree().create_timer(2.0).timeout
	$Enemy.enable()
	$Hud.play_second_floor_dialogue()
	$Baby.refill_bottle()


func _on_hud_dialogue_finished(dialogue_title: String) -> void:
	print("dialogue finished ", dialogue_title)
	
	if dialogue_title == "intro":
		$Map/Friend/AnimatedSprite2D.play("point")
		GameState.intro_played = true
	elif dialogue_title == "second floor":
		$Map.disable_invisible_walls()
		$MusicPlayer/BossMusic.play()
	elif dialogue_title == "victory":
		$Enemy/AnimatedSprite2D.play("death")


func _on_enemy_health_changed(new_health: int) -> void:
	$Hud.update_boss_health_bar(new_health)
	if (new_health <= 0):
		victory_sequence()


func _on_baby_took_damage(remaining_health: float) -> void:
	$Hud.update_baby_health_amount(remaining_health)


func _on_baby_was_defeated() -> void:
	defeat_sequence()
