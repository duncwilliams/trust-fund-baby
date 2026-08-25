extends CanvasLayer

var restart_prompt_delay: int = 2
# backup milk counter purely for making sure restart prompt doesn't display after player collected a carton
var current_milk_amount: int = 100

func _on_baby_milk_amount_changed(new_milk_amount: int) -> void:
	current_milk_amount = new_milk_amount
	%MilkMeterStat.text = str(new_milk_amount)
	if new_milk_amount == 0:
		await get_tree().create_timer(restart_prompt_delay).timeout
		# check again to make sure player did not pick up carton after running out of milk
		if current_milk_amount == 0:
			$RestartPrompt.visible = true
	else:
		$RestartPrompt.visible = false
