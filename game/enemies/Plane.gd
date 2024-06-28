class_name AirPlane
extends Area2D

signal bomb_dropped

@onready var width: int = $plane.texture.get_width() / $plane.hframes
@onready var collision: CollisionShape2D = $CollisionShape2D as CollisionShape2D
@onready var health_bar: HealthBar = $HealthBar as HealthBar

var health: int = 100
var hurting = false
var falling = false
var bomb_dropped = false

var player: Peron

# sin movement
const SIN_FACTOR: float = 0.03
const SIN_HEIGHT: float = 5.0
var sin_accum: float = 0.0
var initial_y: float = 0

func _ready():
	initial_y = 10 + randi() % 50

func _process(delta: float):
	position.x += Constants.PLANE_SPEED * delta
	sin_accum = fmod(sin_accum + SIN_FACTOR, 2 * PI)
	position.y = initial_y - SIN_HEIGHT * sin(sin_accum)

	if hurting:
		health -= Constants.LASER_PLANE_DAMAGE
		if health <= 0:
			queue_free()

	health_bar.update_health(float(health) / 100)

	drop_bomb()

func drop_bomb():
	if bomb_dropped:
		return

	var origin_pos = $BombOrigin.global_position
	var target_pos = player.global_position # TODO: point to the center of the character

	# dy = 1/2*g*t^2
	# t = v(dy/(1/2*g))
	var time_to_hit_target = sqrt((target_pos.y - origin_pos.y) / (0.5 * Constants.GRAVITY))
	var pos_x_to_hit = origin_pos.x + Constants.PLANE_SPEED * time_to_hit_target
	if pos_x_to_hit < target_pos.x:
		bomb_dropped = true
		emit_signal("bomb_dropped", position + $BombOrigin.position)

func _on_Plane_area_entered(area: Area2D):
	if area.name == "Laser":
		hurting = true

func _on_Plane_area_exited(area: Area2D):
	if area.name == "Laser":
		hurting = false
