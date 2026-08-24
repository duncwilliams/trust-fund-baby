extends CanvasLayer

var milk_meter_amount: int = 100

func decrease_milk_meter() -> void:
	milk_meter_amount -= 1
	%MilkMeterStat.text = str(milk_meter_amount)


func refill_milk_meter() -> void:
	milk_meter_amount = 100
	%MilkMeterStat.text = str(milk_meter_amount)


func _on_baby_shot_milk() -> void:
	decrease_milk_meter()
