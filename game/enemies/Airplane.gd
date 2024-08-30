class_name Airplane
extends Entity

const BombScene = preload("res://game/enemies/Bomb.tscn")

@onready var main_layer := get_tree().current_scene.main_layer as Node
@onready var target := get_tree().current_scene.peron as Area2D
@onready var width: int = $plane.texture.get_width() / $plane.hframes
@onready var health_bar := $HealthBar as HealthBar
@onready var bomb_origin := $BombOrigin
@onready var smoke_emitter := $SmokeEmitter as CPUParticles2D
@onready var sparks_emitter := $SparksEmitter as CPUParticles2D

var health := 100
var bomb_dropped := false

# sin movement
const SIN_FACTOR := 0.03
const SIN_HEIGHT := 5.0
var sin_accum := 0.0
var initial_y := 10 + randi() % 50

# fall movement
var vel_y := 0.0

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
	main_layer.add_child(bomb)

func on_destroy_invoked() -> void:
	$AudioStreamPlayer.play()
	ScoreTracker.track_killed(ScoreTracker.EnemyType.PLANE)
	smoke_emitter.emitting = true

func _on_damaged() -> void:
	sparks_emitter.emitting = true
	await get_tree().create_timer(0.2).timeout
	sparks_emitter.emitting = false
