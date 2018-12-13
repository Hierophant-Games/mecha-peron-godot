extends Area2D

onready var Constants = get_node("/root/Constants")
onready var width = $plane.texture.get_width() / $plane.hframes

var health = 100
var hurting = false
var falling = false

# sin movement
const SIN_FACTOR = 0.03
const SIN_HEIGHT = 5
var sin_accum = 0.0
var initial_y = 0

func _enter_tree():
	show()
	health = 100
	initial_y = 10 + randi() % 20

func _process(delta):
	position.x += Constants.PLANE_SPEED * delta
	sin_accum = fmod(sin_accum + SIN_FACTOR, 2 * PI)
	position.y = initial_y - SIN_HEIGHT * sin(sin_accum)
	
	if hurting:
		health -= Constants.LASER_PLANE_DAMAGE
		if health <= 0:
			hide()
	
	# we could use VisibilityNotifier2D for this
	# but I tried and somehow is not working for me :(
	if get_global_transform_with_canvas().origin.x < -width:
		get_parent().remove_child(self)

func _on_Plane_area_entered(area):
	if area.name == "Laser":
		hurting = true

func _on_Plane_area_exited(area):
	if area.name == "Laser":
		hurting = false
