extends Control

const TEXT_SPEED := 30.0

@export_file("*.tscn") var back_scene: String

@onready var credits_text := $MarginContainer/ScrollContainer/CreditsText as Label
@onready var scroll_container := $MarginContainer/ScrollContainer as ScrollContainer

var scroll := 0.0

func _ready():
	# add empty lines at the start and end of the label
	var line_height := credits_text.get_line_height()
	var needed_lines := ceili(get_viewport_rect().size.y / line_height)
	var new_lines := "\n".repeat(needed_lines)
	credits_text.text = new_lines + credits_text.text + new_lines

func _process(delta: float):
	# we need to store the current scroll value in a float because the
	# scroll_vertical property is an int and we lose the decimal part
	scroll += delta * TEXT_SPEED
	scroll_container.scroll_vertical = roundi(scroll)
	
	# start again when reached the end
	if scroll_container.scroll_vertical + scroll_container.size.y >= credits_text.size.y:
		scroll = 0.0

func _on_back_button_pressed():
	$SceneFader.transition_to(back_scene, false)
