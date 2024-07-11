extends Node2D

class_name Soldier

const SHOOT_TIME: int = 6

@onready var width: int = $Sprite2D.texture.get_width() / $Sprite2D.hframes
@onready var health_bar: HealthBar = $HealthBar as HealthBar

var shoot_timer: float = 0
var hurting: bool = false
var dead: bool = false

func _ready():
	$Sprite2D.frame = 0
	shoot_timer = randi() % SHOOT_TIME #randomize start time for shooting

func _process(delta: float):
	if dead:
		return
	
	if $Sprite2D.is_visible_in_tree():
		aim(delta)

func aim(delta):
	shoot_timer += delta
	if shoot_timer >= SHOOT_TIME:
		shoot_timer -= SHOOT_TIME
		$AnimationPlayer.play("aim")
	
func shoot():
	$AnimationPlayer.play("shoot")
	
func reload():
	$AnimationPlayer.play("reload")

func on_health_depleted():
	die()

func die():
	if dead:
		return
	health_bar.hide()
	$Area2D.queue_free()
	dead = true
	$AnimationPlayer.play("die")
