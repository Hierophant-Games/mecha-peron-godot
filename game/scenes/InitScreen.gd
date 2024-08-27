class_name InitScreen
extends ColorRect

const CHAR_TYPING_TIME := 0.06
const CURSOR_TIME := 0.5

@onready var label := $MarginContainer/Label as Label
@onready var full_text := tr("INITIALIZING_TEXT")
@onready var full_text_count := full_text.length()

var _time_accum := 0.0
var _text_accum := 0
var _done := false
var _skip := false
var _cursor_visible := false

func _ready() -> void:
	label.text = ''

func _process(delta: float) -> void:
	if !visible:
		return
	
	_time_accum += delta
	
	if Input.is_action_just_released("ui_accept"):
		if _done:
			hide()
		else:
			_skip = true
	
	if _done:
		if _time_accum > CURSOR_TIME:
			_time_accum -= CURSOR_TIME
			_cursor_visible = !_cursor_visible
			if _cursor_visible:
				label.text += "_"
				$Blip.play()
			else:
				label.text = label.text.trim_suffix("_")
		return
	
	if _time_accum > CHAR_TYPING_TIME:
		_time_accum -= CHAR_TYPING_TIME
		type_text()

func type_text() -> void:
	$Blip.play()
	if _skip:
		var next_line_break := full_text.find("\n", _text_accum)
		_text_accum = next_line_break + 1 if next_line_break > 0 else full_text_count
	else:
		_text_accum += 1
	label.text = full_text.substr(0, _text_accum)
	if _text_accum == full_text_count:
		_done = true
