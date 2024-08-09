class_name HUD
extends MarginContainer

@export var player:Peron

@onready var fist := $Meters/Fist as TextureProgressBar
@onready var health_bar := $Meters/Bars/HealthBar/MarginContainer/ProgressBar as ProgressBar
@onready var laser_bar := $Meters/Bars/LaserBar/MarginContainer/ProgressBar as ProgressBar
@onready var destruction_label := $Score/DestructionLabel as Label
@onready var distance_label := $Score/DistanceLabel as Label

func _process(delta: float) -> void:
	health_bar.value = player.health
	laser_bar.value = player.get_laser_percentage()
	fist.value = player.get_fist_percentage()
	distance_label.text = ScoreTracker.get_distance_text()
	destruction_label.text = ScoreTracker.get_interpolated_score_text(delta)
