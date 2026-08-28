extends Control

signal dialogue_finished(dialogue_title: String)

@export var playtesting: bool = false
@onready var dialogue_text_label: RichTextLabel = %DialogueTextLabel
var listening_for_input: bool = false
var current_tween: Tween
var advance_prompt_timer: SceneTreeTimer
var auto_advance_timer: SceneTreeTimer
var intro_lines: Array[String] = [
	"Oh look, it's a dumb ass baby.",
	"Hey, moron, things aren’t all goo-goo and gah-gah out here, okay?",
	"This is the real world so listen up!",
	"A mighty trust fund was passed to you by your parents.",
	"But your morally bad relatives are here to steal it from you!",
	"You must escape through the attic and track down your relatives.",
	"I'll hold them off, just go!"
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
var victory_lines: Array[String] = [
	"I cannot believe you have done this to me"
]
var defeat_lines: Array[String] = [
	"Your first mistake was trusting me",
	"Your second mistake was fighting a grown man as a baby"
]
var victory_credits_lines: Array[String] = [
	"You did it baby! You reclaimed your trust fund money.",
	"and established yourself as part of the top 1%",
	"please don't spend it all on cryptocurrencies",
	"",
	"thank you for playing our game :)",
	"we hope you enjoyed playing it as much as we enjoyed making it",
	"comment your fastest time below!"
]
var current_dialogue_title: String = ""
var current_lines: Array[String] = []
var line_index: int = 0
var still_typing: bool = false


func _ready() -> void:
	dialogue_text_label.text = ""


func play_intro_dialogue() -> void:
	current_dialogue_title = "intro"
	current_lines = intro_lines
	play_lines()


func play_second_floor_dialogue() -> void:
	current_dialogue_title = "second floor"
	current_lines = second_floor_lines
	play_lines()


func play_victory_dialogue() -> void:
	current_dialogue_title = "victory"
	current_lines = victory_lines
	play_lines()


func play_defeat_dialogue() -> void:
	current_dialogue_title = "defeat"
	current_lines = defeat_lines
	play_lines()


func play_victory_credits_dialogue() -> void:
	await get_tree().create_timer(2.0).timeout
	current_dialogue_title = "victory credits"
	current_lines = victory_credits_lines
	play_lines_auto()


func play_lines() -> void:
	# start listening for inputs
	listening_for_input = true
	
	# shorten all dialogue if playtesting
	if playtesting:
		current_lines = ["playtesting"]
	
	visible = true
	get_tree().paused = true
	line_index = 0
	display_next_line(line_index)


func play_lines_auto() -> void:
	# don't listen for inputs, should already be false, but just for good measure
	listening_for_input = false
	
	visible = true
	line_index = 0
	display_next_line_auto(line_index)


func display_next_line(index: int) -> void:
	dialogue_text_label.text = current_lines[index]
	dialogue_text_label.visible_ratio = 0.0
	still_typing = true
	
	current_tween = create_tween()
	current_tween.tween_property(dialogue_text_label, "visible_ratio", 1.0, current_lines[index].length() * 0.03)
	current_tween.finished.connect(line_is_fully_typed)


func display_next_line_auto(index: int) -> void:
	dialogue_text_label.text = current_lines[index]
	dialogue_text_label.visible_ratio = 0.0
	still_typing = true
	
	current_tween = create_tween()
	current_tween.tween_property(dialogue_text_label, "visible_ratio", 1.0, current_lines[index].length() * 0.03)
	current_tween.finished.connect(line_is_fully_typed_auto)


func line_is_fully_typed() -> void:
	still_typing = false
	advance_prompt_timer = get_tree().create_timer(3.0)
	advance_prompt_timer.timeout.connect(prompt_timer_timed_out)


func line_is_fully_typed_auto() -> void:
	auto_advance_timer = get_tree().create_timer(3.0)
	auto_advance_timer.timeout.connect(auto_advance)


func prompt_timer_timed_out() -> void:
	$AdvanceDialogueLabel.visible = true


func auto_advance() -> void:
	line_index += 1
	if line_index < current_lines.size():
		display_next_line_auto(line_index)
	else:
		visible = false
		dialogue_finished.emit(current_dialogue_title)
		visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and not event is InputEventMouseMotion and listening_for_input:
		if advance_prompt_timer != null and advance_prompt_timer.timeout.is_connected(prompt_timer_timed_out):
			advance_prompt_timer.timeout.disconnect(prompt_timer_timed_out)
		$AdvanceDialogueLabel.visible = false
		if still_typing:
			current_tween.kill()
			dialogue_text_label.visible_ratio = 1.0
			line_is_fully_typed()
		else:
			line_index += 1
			if line_index < current_lines.size():
				display_next_line(line_index)
			else:
				get_tree().paused = false
				visible = false
				dialogue_finished.emit(current_dialogue_title)
				#stop listening for inputs
				listening_for_input = false
				visible = false
