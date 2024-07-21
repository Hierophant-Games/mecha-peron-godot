class_name SceneFader
extends ColorRect

@export_file("*.tscn") var next_scene: String

@onready var anim_player = $AnimationPlayer

func _ready() -> void:
	show()
	anim_player.play_backwards("fade")

func transition_to(_next_scene := next_scene) -> void:
	anim_player.play("fade")
	await anim_player.animation_finished
	get_tree().change_scene_to_file(_next_scene)
