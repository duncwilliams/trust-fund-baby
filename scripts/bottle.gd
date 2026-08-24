extends Node2D

signal shot_milk(launch_angle: Vector2)
signal milk_amount_changed(new_milk_amount: int)

var milk_scene: PackedScene = preload("res://scenes/milk.tscn")
var milk_launch_speed: float = 500.0
var fire_rate: float = 0.02
var can_fire: bool = true
var currently_firing = false
var milk_amount: int = 100

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if (Input.is_action_pressed("shoot_milk") and milk_amount > 0):
		# set currently_firing to true to temporarily disable gravity while BLASTING off
		currently_firing = true
		if can_fire:
			# set can_fire to false so that it can't fire again until fire rate cooldown at end of shoot_milk()
			can_fire = false
			shoot_milk()
	else:
		currently_firing = false


func refill() -> void:
	milk_amount = 100
	milk_amount_changed.emit(milk_amount)
	print("milk_amount: ", milk_amount)


func shoot_milk() -> void:
	var milk = milk_scene.instantiate()
	get_tree().current_scene.add_child(milk)
	milk.global_position = %MuzzlePoint.global_position
	var milk_launch_angle = Vector2.RIGHT.rotated(rotation)
	milk.launch(milk_launch_angle, milk_launch_speed)
	milk_amount -= 1
	shot_milk.emit(milk_launch_angle)
	milk_amount_changed.emit(milk_amount)
	print("milk_amount: ", milk_amount)
	get_tree().create_timer(fire_rate).timeout.connect(func(): can_fire = true)
