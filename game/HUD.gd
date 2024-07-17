class_name HUD
extends MarginContainer

@export var player:Peron

@onready var fist:TextureRect = $HBoxContainer/Fist
@onready var health_bar:ProgressBar = $HBoxContainer/VBoxContainer/HealthBar/MarginContainer/ProgressBar
@onready var laser_bar:ProgressBar = $HBoxContainer/VBoxContainer/LaserBar/MarginContainer/ProgressBar

func _process(_delta: float) -> void:
	health_bar.value = player.health
