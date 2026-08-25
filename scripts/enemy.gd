extends CharacterBody2D


@export var baby: Node2D
var speed: float = 20.0



func _physics_process(delta: float) -> void:
	# sprite orientation
	$AnimatedSprite2D.flip_h = (velocity.x < 0)
	
	if (velocity.is_zero_approx()):
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("walking")
	
	
	# physics and movement
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var distance := global_position.distance_squared_to(baby.global_position)
	print("baby is ", distance, " away from enemy")
	
	var direction := global_position.direction_to(baby.global_position)
	velocity = direction * speed
	#move_and_slide()
