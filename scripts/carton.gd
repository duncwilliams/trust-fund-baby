extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("baby"):
		$AnimatedSprite2D.play("respawning")
		set_deferred("monitorable", false)


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "respawning":
		set_deferred("monitorable", true)
	$AnimatedSprite2D.play("default")
