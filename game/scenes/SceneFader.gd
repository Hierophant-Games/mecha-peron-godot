class_name SceneFader
extends ColorRect

@export_file("*.tscn") var next_scene: String

@onready var anim_player := $AnimationPlayer as AnimationPlayer

static var didnt_fade := false

func _ready() -> void:
	visible = !didnt_fade
	anim_player.play_backwards("fade")

func transition_to(_next_scene := next_scene, fade := true) -> void:
	if fade:
		show()
		anim_player.play("fade")
		await anim_player.animation_finished
	didnt_fade = !fade
	get_tree().change_scene_to_file(_next_scene)
