class_name Airplane
extends Entity

const BombScene = preload("res://game/enemies/Bomb.tscn")

@onready var width: int = $plane.texture.get_width() / $plane.hframes
@onready var health_bar := $HealthBar as HealthBar
@onready var bomb_origin := $BombOrigin

var health := 100
var hurting := false
var bomb_dropped := false

var target: Area2D

# sin movement
const SIN_FACTOR: float = 0.03
const SIN_HEIGHT: float = 5.0
var sin_accum: float = 0.0
var initial_y: float = 0.0

# fall movement
var vel_y: float = 0.0

func _ready():
	assert(target, "Target should be set")
	initial_y = 10 + randi() % 50

func _process(delta: float):
	position.x += Constants.PLANE_SPEED * delta
	
	if !destroyed:
		# sinewave fly pattern
		sin_accum = fmod(sin_accum + SIN_FACTOR, TAU)
		position.y = initial_y - SIN_HEIGHT * sin(sin_accum)
		
		if !bomb_dropped:
			try_drop_bomb()
	else:
		# free falling
		vel_y += Constants.PLANE_GRAVITY * delta
		position.y += vel_y * delta
		rotation = rotate_toward(rotation, PI, delta * 0.25)

func try_drop_bomb():
	var origin_pos = bomb_origin.global_position
	var target_size = (target.shape_owner_get_shape(0, 0) as RectangleShape2D).size
	var target_pos = target.global_position + Vector2(target_size.x, -target_size.y) / 2

	# dy = 1/2*g*t^2
	# t = v(dy/(1/2*g))
	var time_to_hit_target = sqrt((target_pos.y - origin_pos.y) / (0.5 * Constants.GRAVITY))
	var pos_x_to_hit = origin_pos.x + Constants.PLANE_SPEED * time_to_hit_target
	if pos_x_to_hit < target_pos.x:
		bomb_dropped = true
		spawn_bomb(bomb_origin.position + position)

func spawn_bomb(bomb_position: Vector2):
	var bomb := BombScene.instantiate() as Bomb
	bomb.position = bomb_position
	var main_layer := get_tree().current_scene.main_layer as Node
	main_layer.add_child(bomb)
