extends Area2D

var velocity: Vector2 = Vector2.ZERO
var lifetime: float = 4.0


func _physics_process(delta: float) -> void:
	position += velocity * delta


func launch(direction: Vector2, speed: float) -> void:
	velocity = direction * speed
	get_tree().create_timer(lifetime).timeout.connect(queue_free)


func _on_area_entered(area: Area2D) -> void:
	if (not area.is_in_group("baby") and not area.is_in_group("milk") and not area.is_in_group("carton")):
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if (not body.is_in_group("baby") and not body.is_in_group("milk") and not body.is_in_group("carton")):
		queue_free()
