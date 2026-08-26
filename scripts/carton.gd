extends Area2D

var respawning: bool = false


func play_respawn_animation() -> void:
	$AnimatedSprite2D.play("respawning")
	respawning = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "respawning":
		respawning = false
	$AnimatedSprite2D.play("default")
