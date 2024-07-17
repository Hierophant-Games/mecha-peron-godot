class_name HUD
extends MarginContainer

@export var player:Peron

@onready var fist:TextureProgressBar = $HBoxContainer/Fist
@onready var health_bar:ProgressBar = $HBoxContainer/VBoxContainer/HealthBar/MarginContainer/ProgressBar
@onready var laser_bar:ProgressBar = $HBoxContainer/VBoxContainer/LaserBar/MarginContainer/ProgressBar

func _process(_delta: float) -> void:
	health_bar.value = player.health
	laser_bar.value = player.get_laser_percentage()
	fist.value = player.get_fist_percentage()
