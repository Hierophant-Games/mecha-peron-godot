class_name Soldier
extends Entity

const RocketScene = preload("res://game/enemies/Rocket.tscn")
@onready var width: int = $Sprite2D.texture.get_width() / $Sprite2D.hframes
@onready var health_bar: HealthBar = $HealthBar as HealthBar

var shoot_timer: float = 0
var hurting: bool = false
var main_layer: WeakRef

func _ready():
	$Sprite2D.frame = 0
	shoot_timer = randf() * Constants.SOLDIER_SHOOT_TIME #randomize start time for shooting

func _process(delta: float):
	if destroyed:
		return
	
	if $Sprite2D.is_visible_in_tree():
		aim(delta)

func aim(delta):
	shoot_timer += delta
	if shoot_timer >= Constants.SOLDIER_SHOOT_TIME:
		shoot_timer -= Constants.SOLDIER_SHOOT_TIME
		$AnimationPlayer.play("aim")
	
func shoot():
	$AnimationPlayer.play("shoot")
	
func reload():
	$AnimationPlayer.play("reload")

func spawn_rocket():
	var rocket: Rocket = RocketScene.instantiate() as Rocket
	main_layer.get_ref().add_child(rocket)
	rocket.global_position = $RocketSpawnNode.global_position

func on_health_depleted():
	die()

func die():
	if destroyed:
		return
	$Area2D.queue_free()
	destroyed = true
	$AnimationPlayer.play("die")
