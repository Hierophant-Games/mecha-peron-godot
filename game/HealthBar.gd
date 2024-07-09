@tool
extends Polygon2D

class_name HealthBar

signal owner_died

@export var width: int = 20: set = set_width
@export var height: int = 2: set = set_height

const FADE_TIME: float = 0.4
var fade_timer: float = 0.0

func set_width(new_width: int):
	width = new_width
	update_geometry()

func set_height(new_height: int):
	height = new_height
	update_geometry()

func _ready():
	update_geometry()
	if !Engine.is_editor_hint():
		visible = false # start hidden in game

func update_geometry():
	var polygon_data = PackedVector2Array([
		Vector2(0, 0),
		Vector2(width, 0),
		Vector2(width, height),
		Vector2(0, height)
	])

	polygon = polygon_data
	$progress.polygon = polygon_data

func update_health(ratio: float):
	if is_equal_approx(ratio, $progress.scale.x):
		fade_timer += get_process_delta_time()
		var alpha = clamp(1 - (fade_timer / FADE_TIME), 0, 1)
		modulate = Color(1, 1, 1, alpha)
		if is_zero_approx(alpha):
			visible = false
		return

	fade_timer = 0.0
	visible = true
	modulate = Color(1, 1, 1, 1)
	$progress.scale = Vector2(ratio, 1)

	# compute the progress color:
	# - red when ratio is 0
	# - green when ratio is 1
	# - yellow (red+green) when ratio is near 0.5

	var red: float = (1 - ratio)
	var green: float = ratio
	var diff: float = abs(red - green)
	var influence: float = (1 - diff) / 2
	red += influence
	green += influence

	$progress.color = Color(red, green, 0)
	
	owner_died.emit()
