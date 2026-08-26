extends CharacterBody2D

signal health_changed(new_health: int)

@onready var baby: Node2D = get_tree().get_first_node_in_group("baby")
var speed: float = 4.0
var health: int = 400


func _physics_process(delta: float) -> void:
	# sprite handling
	if abs(velocity.x) < 10:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.play("walking")
	
	
	# physics and movement
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction := global_position.direction_to(baby.global_position)
	# sprite orientation
	$AnimatedSprite2D.flip_h = (direction.x > 0)
	velocity += direction * speed
	move_and_slide()


func enable() -> void:
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT


func disable() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED


func take_damage() -> void:
	health -= 1
	health_changed.emit(health)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("milk"):
		take_damage()
