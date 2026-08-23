extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var thrust_force: float = 400

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()


func milk_thrust(thrust_angle) -> void:
	velocity = thrust_angle * thrust_force


func _on_bottle_shot_milk(milk_launch_angle: Vector2) -> void:
	milk_thrust(-milk_launch_angle)
