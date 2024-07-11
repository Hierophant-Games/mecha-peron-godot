class_name Damageable
extends Node

signal health_depleted

@export var destroyable: Destroyable = null
@export var health_bar: HealthBar
@export var area_2d: Area2D
@export var laser_damage: int
@export var health: float = 100.0:
	set(value):
		health = value
		health_bar.ratio = float(value) / 100
		if value <= 0:
			health_depleted.emit()

func _ready():
	if destroyable:
		health_depleted.connect(destroyable.destroy)

func _enter_tree():
	assert(owner is Node2D, "Owner must be Node2D")
	owner.set_meta("damageable", self)
	if owner.has_method("on_health_depleted"):
		health_depleted.connect(owner.on_health_depleted)

func damage():
	health -= laser_damage
