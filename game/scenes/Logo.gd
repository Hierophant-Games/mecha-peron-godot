extends Control

func _on_timer_timeout():
	$SceneFader.transition_to()
