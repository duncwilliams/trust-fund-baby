extends CanvasLayer

func _on_baby_milk_amount_changed(new_milk_amount: int) -> void:
	%MilkMeterStat.text = str(new_milk_amount)
