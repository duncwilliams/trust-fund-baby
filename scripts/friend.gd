extends StaticBody2D


func _ready() -> void:
	$AnimatedSprite2D.play("point")


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("idle")
