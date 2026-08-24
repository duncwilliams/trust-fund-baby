extends CanvasLayer

var restart_prompt_delay: int = 2

func _on_baby_milk_amount_changed(new_milk_amount: int) -> void:
	%MilkMeterStat.text = str(new_milk_amount)
	if new_milk_amount == 0:
		await get_tree().create_timer(restart_prompt_delay).timeout
		$RestartPrompt.visible = true
	else:
		$RestartPrompt.visible = false
