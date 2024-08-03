class_name ButtonList
extends VBoxContainer

func _ready():
	_on_visibility_changed()
	visibility_changed.connect(_on_visibility_changed)

func _process(_delta: float):
	fix_hover_focus()

## Prevent showing the hovered button and the focused button at the same time
## Simply grab focus when hovering a button
func fix_hover_focus():
	for button: Button in get_children():
		if button.is_hovered():
			button.grab_focus()

func _on_visibility_changed():
	if visible:
		get_child(0).grab_focus()
