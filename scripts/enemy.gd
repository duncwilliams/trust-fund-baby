extends CharacterBody2D

@onready var baby: Node2D = get_tree().get_first_node_in_group("baby")
var speed: float = 5.0


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
	
	var direction := global_position.direction_to(baby.global_position)
	velocity += direction * speed
	move_and_slide()
