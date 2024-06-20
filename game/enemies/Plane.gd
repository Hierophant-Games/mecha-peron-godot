extends Area2D

onready var width: int = $plane.texture.get_width() / $plane.hframes
onready var health_bar: HealthBar = $HealthBar as HealthBar

var health: int = 100
var hurting = false
var falling = false

# sin movement
const SIN_FACTOR: float = 0.03
const SIN_HEIGHT: float = 5.0
var sin_accum: float = 0.0
var initial_y: float = 0

func _enter_tree():
	show()
	health = 100
	initial_y = 10 + randi() % 20

func _process(delta: float):
	position.x += Constants.PLANE_SPEED * delta
	sin_accum = fmod(sin_accum + SIN_FACTOR, 2 * PI)
	position.y = initial_y - SIN_HEIGHT * sin(sin_accum)

	if hurting:
		health -= Constants.LASER_PLANE_DAMAGE
		if health <= 0:
			hide()

	health_bar.update_health(float(health) / 100)

	# we could use VisibilityNotifier2D for this
	# but I tried and somehow is not working for me :(
	if get_global_transform_with_canvas().origin.x < -width:
		get_parent().remove_child(self)

func _on_Plane_area_entered(area: Area2D):
	if area.name == "Laser":
		hurting = true

func _on_Plane_area_exited(area: Area2D):
	if area.name == "Laser":
		hurting = false
