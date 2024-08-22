class_name EnemyBuilding
extends Entity

const SoldierScene := preload("res://game/enemies/Soldier.tscn")

const MIN_SOLDIERS := 8
const MAX_ADDITIONAL_SOLDIERS := 8

var soldiers: Array[Soldier] = []

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
									preload("res://game/sfx/soldier_death_6.mp3"),]

func _enter_tree() -> void:
	$Sprite2D.frame = 0
	populate()

func populate() -> void:
	var soldier_count := randi() % MAX_ADDITIONAL_SOLDIERS + MIN_SOLDIERS
	
	for node in get_random_spawn_points(soldier_count):
		var soldier := SoldierScene.instantiate() as Soldier
		soldier.setup(sfx_shoot, sfx_reload, sfx_death)
		node.add_child(soldier)
		soldiers.append(soldier)

func get_random_spawn_points(count) -> Array[Node]:
	var spawn_points := $Sprite2D/SpawnArea.get_children()
	spawn_points.shuffle()
	return spawn_points.slice(0, count-1)

func on_destroy_invoked() -> void:
	VFX.shake(0.01, 10)
	$AudioStreamPlayer.play()
	for soldier in soldiers:
		soldier.die()
	ScoreTracker.track_killed(ScoreTracker.EnemyType.BUILDING)
