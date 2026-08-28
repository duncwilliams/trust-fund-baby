extends Node2D

signal shot_milk(launch_angle: Vector2)
signal milk_amount_changed(new_milk_amount: int)

var milk_scene: PackedScene = preload("res://scenes/milk.tscn")
var milk_launch_speed: float = 500.0
var shots_per_second: float = 60.0
var drain_per_second: float = 40.0
var currently_firing: bool = false
var milk_amount: int = 100
var fire_accumulator: float = 0.0
var drain_accumulator: float = 0.0


func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())


func _physics_process(delta: float) -> void:
	if $AnimatedSprite2D.visible:
		if Input.is_action_pressed("shoot_milk") and milk_amount > 0:
			currently_firing = true

			fire_accumulator += shots_per_second * delta
			while fire_accumulator >= 1.0:
				fire_accumulator -= 1.0
				shoot_milk()

			drain_accumulator += drain_per_second * delta
			while drain_accumulator >= 1.0 and milk_amount > 0:
				drain_accumulator -= 1.0
				drain_milk()
		else:
			currently_firing = false
			fire_accumulator = 0.0
	
	# sprite handling
	if milk_amount == 100:
		$AnimatedSprite2D.play("full")
	elif milk_amount >= 75:
		$AnimatedSprite2D.play("75_plus")
	elif milk_amount >= 50:
		$AnimatedSprite2D.play("50_plus")
	elif milk_amount >= 25:
		$AnimatedSprite2D.play("25_plus")
	elif milk_amount >= 1:
		$AnimatedSprite2D.play("1_plus")
	else:
		$AnimatedSprite2D.play("empty")


func refill() -> void:
	milk_amount = 100
	milk_amount_changed.emit(milk_amount)
	$MilkRefillAudio.play()


func empty() -> void:
	milk_amount = 0
	milk_amount_changed.emit(milk_amount)


func shoot_milk() -> void:
	var milk = milk_scene.instantiate()
	get_tree().current_scene.add_child(milk)
	milk.global_position = %MuzzlePoint.global_position
	var milk_launch_angle = Vector2.RIGHT.rotated(rotation)
	milk.launch(milk_launch_angle, milk_launch_speed)
	shot_milk.emit(milk_launch_angle)
	$ShootMilkAudio.play()


func drain_milk() -> void:
	milk_amount -= 1
	milk_amount_changed.emit(milk_amount)
