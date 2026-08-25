extends Control

@onready var dialogue_text_label: RichTextLabel = %DialogueTextLabel
# hoping to make this scene and script work with multiple different dialogue lines sets if possible later
var second_floor_lines: Array[String] = [
	"oh look it's a dumb ass baby",
	"little moron baby probably don't even know 2 + 2",
	"probably don't even know 1 + 1 for that matter",
	"I'm gonna beat your ass and steal your fortune"
]
var current_lines: Array[String] = []
var line_index: int = 0
var still_typing: bool = false


func play_second_floor_dialogue():
	print("playing second floor dialogue")
	get_tree().paused = true
	line_index = 0
	current_lines = second_floor_lines
	display_next_line(line_index)


func display_next_line(index: int):
	dialogue_text_label.text = current_lines[index]
	dialogue_text_label.visible_ratio = 0.0
	still_typing = true
	
	var tween := create_tween()
	tween.tween_property(dialogue_text_label, "visible_ratio", 1.0, current_lines[index].length() * 0.03)
	tween.finished.connect(func(): still_typing = false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialogue"):
		if still_typing:
			# show full line of dialogue immediately
			dialogue_text_label.visible_ratio = 1.0
			still_typing = false
		else:
			line_index += 1
			if line_index < current_lines.size():
				display_next_line(line_index)
			else:
				get_tree().paused = false
				queue_free()
			
