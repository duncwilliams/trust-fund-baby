extends CanvasLayer

signal dialogue_finished(dialogue_title: String)

var restart_prompt_delay: int = 3
# backup milk counter purely for making sure restart prompt doesn't display after player collected a carton
var current_milk_amount: int = 100

func play_second_floor_dialogue():
	$DialogueController.play_second_floor_dialogue()


func update_boss_health_bar(new_health: int):
	%BossHealthBar.value = new_health


func update_milk_amount(new_milk_amount: int) -> void:
	current_milk_amount = new_milk_amount
	%MilkMeterStat.text = str(new_milk_amount)
	if new_milk_amount == 0:
		await get_tree().create_timer(restart_prompt_delay).timeout
		# check again to make sure player did not pick up carton after running out of milk
		if current_milk_amount == 0:
			$RestartPrompt.visible = true
	else:
		$RestartPrompt.visible = false


func _on_dialogue_controller_dialogue_finished(dialogue_title: String) -> void:
		dialogue_finished.emit(dialogue_title)
		$BossBarControl.visible = true
