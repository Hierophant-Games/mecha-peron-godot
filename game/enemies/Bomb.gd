class_name Bomb
extends Area2D

@onready var health_bar: HealthBar = $HealthBar as HealthBar

var vel_y: float = 0.0
var hurting: bool = false
var health: float = 100.0

func _process(delta: float):
	vel_y += Constants.GRAVITY * delta

	position.x += Constants.PLANE_SPEED * delta
	position.y += vel_y * delta

	if hurting:
		# This was not used in the original game but we might want to?
		#health -= Constants.LASER_CANNON_BOMB_DAMAGE
		if health <= 0:
			queue_free()

	health_bar.update_health(float(health) / 100)

func _on_Bomb_area_entered(area: Area2D):
	if area.name == "Laser":
		hurting = true

func _on_Bomb_area_exited(area: Area2D):
	if area.name == "Laser":
		hurting = false
