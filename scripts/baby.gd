extends CharacterBody2D

signal milk_amount_changed(new_milk_amount: int)

@onready var bottle: Node2D = %Bottle
var thrust_force: float = 15
var max_velocity: float = 600

func _physics_process(delta: float) -> void:
	# gravity
	if (not is_on_floor() and not bottle.currently_firing) :
		velocity += get_gravity() * delta
	
	move_and_slide()


func milk_thrust(thrust_angle: Vector2) -> void:
	velocity += thrust_angle * thrust_force
	velocity = velocity.limit_length(max_velocity)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("carton"):
		area.queue_free()
		bottle.refill()

func _on_bottle_shot_milk(milk_launch_angle: Vector2) -> void:
	milk_thrust(-milk_launch_angle)


func _on_bottle_milk_amount_changed(new_milk_amount: int) -> void:
	milk_amount_changed.emit(new_milk_amount)
