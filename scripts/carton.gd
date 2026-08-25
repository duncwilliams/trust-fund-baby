extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("baby"):
		monitoring = false
		$AnimatedSprite2D.play("respawning")


func _on_animated_sprite_2d_animation_finished() -> void:
	monitoring = true
	$AnimatedSprite2D.play("default")
