class_name EnemyBuilding
extends Entity

const SoldierScene := preload("res://game/enemies/Soldier.tscn")

const MIN_SOLDIERS := 8
const MAX_ADDITIONAL_SOLDIERS := 8

var soldiers: Array[Soldier] = []

func _enter_tree() -> void:
	$Sprite2D.frame = 0
	populate()

func populate() -> void:
	var soldier_count := randi() % MAX_ADDITIONAL_SOLDIERS + MIN_SOLDIERS
	
	for node in get_random_spawn_points(soldier_count):
		var soldier := SoldierScene.instantiate() as Soldier
		node.add_child(soldier)
		soldiers.append(soldier)

func get_random_spawn_points(count) -> Array[Node]:
	var spawn_points := $Sprite2D/SpawnArea.get_children()
	spawn_points.shuffle()
	return spawn_points.slice(0, count-1)

func on_destroy_invoked() -> void:
	for soldier in soldiers:
		soldier.die()
