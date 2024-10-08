extends Node

const FlashEffectScene := preload("res://game/vfx/FlashEffect.tscn")

var canvas_layer: CanvasLayer

func _ready() -> void:
	# Create a new CanvasLayer that will be on top of all the nodes in the game
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 10
	canvas_layer.name = "VFXLayer"
	get_tree().root.add_child.call_deferred(canvas_layer)

## Flash the screen with a Color, for a given time
func flash(color := Color.WHITE, duration := 1.0) -> void:
	var flash_effect := FlashEffectScene.instantiate() as FlashEffect
	flash_effect.color = color
	flash_effect.duration = duration
	canvas_layer.add_child(flash_effect)

## Shake the screen like crazy
func shake(intensity := 0.05, duration := 0.5) -> void:
	var shake_effect := ShakeEffect.new()
	shake_effect.intensity = intensity
	shake_effect.duration = duration
	get_tree().root.add_child(shake_effect)
