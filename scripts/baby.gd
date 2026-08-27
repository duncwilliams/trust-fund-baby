extends CharacterBody2D

signal milk_amount_changed(new_milk_amount: int)
signal took_damage(remaining_health: float)

@onready var bottle: Node2D = %Bottle
var thrust_force: float = 15
var max_velocity: float = 560
var health: float = 4.0
var invincible: bool = false
var i_frames_time: float = 2.0
var defeated: bool = false


func _physics_process(delta: float) -> void: 
	# sprite orientation
	$AnimatedSprite2D.flip_h = (velocity.x < 0)
	
	if not defeated:
		# area overlap detection
		for area in $Area2D.get_overlapping_areas():
			if area.is_in_group("carton"):
				if not area.respawning:
					area.play_respawn_animation()
					refill_bottle()
			elif area.is_in_group("enemy"):
				take_damage()
		
		# physics
		if ((not is_on_floor()) and (not bottle.currently_firing)) :
			velocity += get_gravity() * delta
		
		move_and_slide()
	else:
		velocity += get_gravity() * delta


func milk_thrust(thrust_angle: Vector2) -> void:
	velocity += thrust_angle * thrust_force
	velocity = velocity.limit_length(max_velocity)


func refill_bottle():
	bottle.refill()


func empty_bottle():
	# i'm like an empty bottle, drained of everything left in my mind
	bottle.empty()


func take_damage():
	if (not invincible):
		invincible = true
		health -= 0.5
		if health <= 0.0:
			defeat()
		took_damage.emit(health)
		$AnimatedSprite2D.play("damage")
		# i frames
		await get_tree().create_timer(i_frames_time).timeout
		invincible = false


func defeat():
	defeated = true
	$Bottle/AnimatedSprite2D.visible = false
	$Bottle.process_mode = Node.PROCESS_MODE_DISABLED
	$CharacterBodyCollision.set_deferred("disabled", true)
	$Area2D/AreaCollision.set_deferred("disabled", true)
	print("baby defeated")
	$AnimatedSprite2D.play("defeat")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("map"):
		$AnimatedSprite2D.play("collide")


func _on_bottle_shot_milk(milk_launch_angle: Vector2) -> void:
	milk_thrust(-milk_launch_angle)


func _on_bottle_milk_amount_changed(new_milk_amount: int) -> void:
	milk_amount_changed.emit(new_milk_amount)


func _on_animated_sprite_2d_animation_finished() -> void:
	if not $AnimatedSprite2D.animation == "defeat":
		$AnimatedSprite2D.play("default")
