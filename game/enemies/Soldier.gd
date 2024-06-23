extends Area2D

class_name Soldier

const SHOOT_TIME: int = 6

onready var width: int = $Sprite.texture.get_width() / $Sprite.hframes
onready var health_bar: HealthBar = $HealthBar as HealthBar

var shootTimer: float = 0
var hurting: bool = false
var health: int = 100
var dead: bool = false

func _enter_tree():
	$Sprite.frame = 0
	health = 100
	shootTimer = randi() % SHOOT_TIME #randomize start time for shooting

func _process(delta: float):
	if dead:
		return
	process_damage()
	health_bar.update_health(float(health) / 100)
	if health <= 0:
		die()
	
	if $Sprite.is_visible_in_tree():
		aim(delta)

func process_damage():
	for area in self.get_overlapping_areas():
		if area is Laser:
			health -= Constants.LASER_SOLDIER_DAMAGE
			return

func aim(delta):
	shootTimer += delta
	if shootTimer >= SHOOT_TIME:
		shootTimer -= SHOOT_TIME
		$AnimationPlayer.play("aim")
	
func shoot():
	$AnimationPlayer.play("shoot")
	
func reload():
	$AnimationPlayer.play("reload")

func die():
	health = 0
	health_bar.hide()
	dead = true
	$AnimationPlayer.play("die")
