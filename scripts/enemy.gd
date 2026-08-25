extends CharacterBody2D


@export var baby: Node2D
var speed: float = 100.0



func _physics_process(delta: float) -> void:
	# sprite orientation
	$AnimatedSprite2D.flip_h = (velocity.x < 0)
	
	if (velocity.is_zero_approx()):
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("walking")
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
