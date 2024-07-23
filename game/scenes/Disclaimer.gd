extends Control

@onready var of_course_text := $MarginContainer/OfCourse as Label
@onready var disclaimer_timer := $DisclaimerTimer as Timer
@onready var transition_timer := $TransitionTimer as Timer

func _ready():
	of_course_text.hide()

func _input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		if !disclaimer_timer.is_stopped():
			force_timeout(disclaimer_timer)
		elif !transition_timer.is_stopped():
			force_timeout(transition_timer)

func _on_disclaimer_timer_timeout():
	of_course_text.show()
	transition_timer.start()

func _on_transition_timer_timeout():
	$SceneFader.transition_to()

func force_timeout(timer: Timer):
	timer.stop()
	timer.timeout.emit()
