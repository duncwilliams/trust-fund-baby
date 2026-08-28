extends CanvasLayer

signal dialogue_finished(dialogue_title: String)

var restart_prompt_delay: int = 5
# backup milk counter purely for making sure restart prompt doesn't display after player collected a carton
var current_milk_amount: int = 100
var in_boss_battle = false
var fullscreen_display_time: float = 3.0
var fullscreen_fade_time: float = 1.0
var restart_prompt_pending: bool = false


func _ready() -> void:
	$RestartPrompt.visible = false
	$DefeatRespawnPrompt.visible = false
	$HeartsControl.visible = false
	$BossBarControl.visible = false
	$ReplayPrompt.visible = false
	$RestartPromptTimer.wait_time = restart_prompt_delay
	$RestartPromptTimer.timeout.connect(restart_prompt_timer_timeout)


func update_milk_amount(new_milk_amount: int) -> void:
	current_milk_amount = new_milk_amount
	%MilkMeterStat.text = str(new_milk_amount)
	if new_milk_amount == 0 and not in_boss_battle:
		$RestartPromptTimer.start()  # restarts from full duration even if already running
	else:
		$RestartPromptTimer.stop()
		$RestartPrompt.visible = false


func update_baby_health_amount(new_health_amount: float) -> void:
	# hearts sprite handling
	if new_health_amount == 4:
		%HeartsSprite.play("full_hearts")
	elif new_health_amount == 3.5:
		%HeartsSprite.play("three_and_half_hearts")
	elif new_health_amount == 3.0:
		%HeartsSprite.play("three_hearts")
	elif new_health_amount == 2.5:
		%HeartsSprite.play("two_and_half_hearts")
	elif new_health_amount == 2.0:
		%HeartsSprite.play("two_hearts")
	elif new_health_amount == 1.5:
		%HeartsSprite.play("one_and_half_hearts")
	elif new_health_amount == 1.0:
		%HeartsSprite.play("one_heart")
	elif new_health_amount == 0.5:
		%HeartsSprite.play("half_heart")
	else:
		%HeartsSprite.play("no_hearts")
		$MilkMeterControl.visible = false


func play_fullscreen_intro_message():
	$FullscreenMessageControl.visible = true
	get_tree().paused = true
	await get_tree().create_timer(fullscreen_display_time).timeout
	var tween := create_tween()
	tween.tween_property($FullscreenMessageControl, "modulate:a", 0.0, fullscreen_fade_time)
	await tween.finished

	get_tree().paused = false
	$FullscreenMessageControl.queue_free()


func play_intro_dialogue():
	$DialogueController.play_intro_dialogue()


func play_second_floor_dialogue():
	$DialogueController.play_second_floor_dialogue()


func update_boss_health_bar(new_health: int):
	%BossHealthBar.value = new_health


func restart_prompt_timer_timeout() -> void:
	if current_milk_amount == 0:
		$RestartPrompt.visible = true


func _on_dialogue_controller_dialogue_finished(dialogue_title: String) -> void:
		dialogue_finished.emit(dialogue_title)
		if dialogue_title == "second floor":
			$BossBarControl.visible = true
			$HeartsControl.visible = true
			in_boss_battle = true
		if dialogue_title == "victory":
			$BossBarControl.visible = false
		if dialogue_title == "defeat":
			$DefeatRespawnPrompt.visible = true
