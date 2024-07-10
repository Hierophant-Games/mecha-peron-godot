class_name Damageable
extends Node

@export var destroyable: Destroyable = null
@export var health_bar: HealthBar
@export var area_2d: Area2D
@export var laser_damage: int
@export var health: float = 100.0:
	set(value):
		health = value
		health_bar.update_health(float(value) / 100)

func _ready():
	if destroyable:
		health_bar.owner_died.connect(destroyable.destroy)

func _enter_tree():
	assert(owner is Node2D, "Owner must be Node2D")
	owner.set_meta("damageable", self)

func damage():
	health -= laser_damage
