extends Node


func fade_out_background_music(duration: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property($BackgroundMusic, "volume_db", -80.0, duration)
	await tween.finished
	$BackgroundMusic.stop()
	$BackgroundMusic.volume_db = -14.0


func fade_out_boss_music(duration: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property($BossMusic, "volume_db", -80.0, duration)
	await tween.finished
	$BossMusic.stop()
	$BossMusic.volume_db = -8.0
