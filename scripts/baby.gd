extends CharacterBody2D

signal shot_milk

var thrust_force: float = 400

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()


func milk_thrust(thrust_angle: Vector2) -> void:
	velocity = thrust_angle * thrust_force
	shot_milk.emit()


func _on_bottle_shot_milk(milk_launch_angle: Vector2) -> void:
	milk_thrust(-milk_launch_angle)
