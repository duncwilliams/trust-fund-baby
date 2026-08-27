extends Control

signal dialogue_finished(dialogue_title: String)

@export var playtesting: bool = false
@onready var dialogue_text_label: RichTextLabel = %DialogueTextLabel
var intro_lines: Array[String] = [
	"Oh look, it's a dumb ass baby.",
	"Hey, moron, things aren’t all goo-goo and gah-gah out here, okay?",
	"This is the real world so listen up!",
	"A mighty trust fund was passed to you by your parents.",
	"But some people – your morally bad relatives – have stolen it from you!",
	"You must escape through the attic and track down your relatives.",
	"Be careful, they are crafty.",
	"Trust no one!"
]
var second_floor_lines: Array[String] = [
	"Well, well, well",
	"Didn't I tell your dumb ass not to trust anyone?",
	"I am your morally bad and corrupt brother!",
	"Our parents trapped me here to prevent me from escaping",
	"And stealing your trust fund",
	"But you and your dumb balloon bandolier freed me!",
	"Sorry, loser, I can’t let you witness my grand heist."
]
#TODO: add victory and defeat dialogue
var current_dialogue_title: String = ""
var current_lines: Array[String] = []
var line_index: int = 0
var still_typing: bool = false


func _ready() -> void:
	dialogue_text_label.text = ""


func play_intro_dialogue():
	current_dialogue_title = "intro"
	current_lines = intro_lines
	play_lines()


func play_second_floor_dialogue():
	current_dialogue_title = "second floor"
	current_lines = second_floor_lines
	play_lines()


func play_lines():
	# shorten all dialogue if playtesting
	if playtesting:
		current_lines = ["playtesting"]
	
	visible = true
	get_tree().paused = true
	line_index = 0
	display_next_line(line_index)


func display_next_line(index: int):
	dialogue_text_label.text = current_lines[index]
	dialogue_text_label.visible_ratio = 0.0
	still_typing = true
	
	var tween := create_tween()
	tween.tween_property(dialogue_text_label, "visible_ratio", 1.0, current_lines[index].length() * 0.03)
	tween.finished.connect(func(): still_typing = false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialogue") and not still_typing:
		line_index += 1
		if line_index < current_lines.size():
			display_next_line(line_index)
		else:
			get_tree().paused = false
			visible = false
			dialogue_finished.emit(current_dialogue_title)
