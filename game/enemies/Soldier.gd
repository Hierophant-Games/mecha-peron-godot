class_name Soldier
extends Entity

const RocketScene := preload("res://game/enemies/Rocket.tscn")

@onready var width: int = $Sprite2D.texture.get_width() / $Sprite2D.hframes
@onready var health_bar := $HealthBar as HealthBar
@onready var main_layer := get_tree().current_scene.main_layer as Node
@onready var sfx_voice := $Voice as AudioStreamPlayer

const sfx_shoot: Array[AudioStream] = [preload("res://game/sfx/soldier_fire_1.mp3"),
										preload("res://game/sfx/soldier_fire_2.mp3"),
										preload("res://game/sfx/soldier_fire_3.mp3")]
const sfx_reload: Array[AudioStream] = [preload("res://game/sfx/soldier_reload_1.mp3"),
										preload("res://game/sfx/soldier_reload_2.mp3"),
										preload("res://game/sfx/soldier_reload_3.mp3")]
const sfx_death: Array[AudioStream] = [preload("res://game/sfx/soldier_death_1.mp3"),
									preload("res://game/sfx/soldier_death_2.mp3"),
									preload("res://game/sfx/soldier_death_3.mp3"),
									preload("res://game/sfx/soldier_death_4.mp3"),
									preload("res://game/sfx/soldier_death_5.mp3"),
									preload("res://game/sfx/soldier_death_6.mp3")]

var shoot_timer := 0.0

func _ready():
	sfx_voice.volume_db = linear_to_db(Constants.SOLDIER_VOLUME_MODIFIER)
	$Sprite2D.frame = 0
	shoot_timer = randf() * Constants.SOLDIER_SHOOT_TIME #randomize start time for shooting

func _process(delta: float):
	if destroyed:
		return
	
	if $Sprite2D.is_visible_in_tree():
		aim(delta)

func aim(delta: float):
	shoot_timer += delta
	if shoot_timer >= Constants.SOLDIER_SHOOT_TIME:
		shoot_timer -= Constants.SOLDIER_SHOOT_TIME
		$AnimationPlayer.play("aim")
	
func shoot():
	$AnimationPlayer.play("shoot")
	sfx_voice.set_stream(sfx_shoot.pick_random())
	sfx_voice.play()
	
func reload():
	$AnimationPlayer.play("reload")
	sfx_voice.set_stream(sfx_reload.pick_random())
	sfx_voice.play()

func spawn_rocket():
	var rocket := RocketScene.instantiate() as Rocket
	main_layer.add_child(rocket)
	rocket.global_position = $RocketSpawnNode.global_position

func on_health_depleted():
	die()

func die():
	sfx_voice.set_stream(sfx_death.pick_random())
	sfx_voice.play()
	if destroyed:
		return
	$Area2D.queue_free()
	destroyed = true
	$AnimationPlayer.play("die")
	ScoreTracker.track_killed(ScoreTracker.EnemyType.SOLDIER)
