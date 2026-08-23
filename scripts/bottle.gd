extends Node2D

signal shot_milk(launch_angle: Vector2)

var milk_scene: PackedScene = preload("res://scenes/milk.tscn")
var milk_launch_speed: float = 600.0
var fire_rate: float = 0.15
var can_fire: bool = true

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if (Input.is_action_pressed("shoot_milk") and can_fire):
		can_fire = false
		shoot_milk()


func shoot_milk() -> void:
	var milk = milk_scene.instantiate()
	get_tree().current_scene.add_child(milk)
	milk.global_position = %MuzzlePoint.global_position
	var milk_launch_angle = Vector2.RIGHT.rotated(rotation)
	milk.launch(milk_launch_angle, milk_launch_speed)
	shot_milk.emit(milk_launch_angle)
	get_tree().create_timer(fire_rate).timeout.connect(func(): can_fire = true)
