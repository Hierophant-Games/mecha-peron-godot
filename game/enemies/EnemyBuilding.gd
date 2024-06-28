extends Area2D

class_name EnemyBuilding

const SoldierScene = preload("res://game/enemies/Soldier.tscn")

const MIN_SOLDIERS = 8
const MAX_ADDITIONAL_SOLDIERS = 8

var soldiers: Array[Soldier] = []
var is_destroyed = false

func _enter_tree():
	$Sprite2D.frame = 0
	populate()

func populate():
	var soldier_count = randi() % MAX_ADDITIONAL_SOLDIERS + MIN_SOLDIERS
	
	for node in get_random_spawn_points(soldier_count):
		var soldier: Soldier = SoldierScene.instantiate() as Soldier
		node.add_child(soldier)
		soldiers.append(soldier)

func get_random_spawn_points(count):
	var spawn_points = $Sprite2D/SpawnArea.get_children()
	spawn_points.shuffle()
	return spawn_points.slice(0, count-1)

func kill():
	queue_free()

func _on_EnemyBuilding_area_entered(area):
	if area is Fist:
		area.queue_free() # destroy fist
		if is_destroyed:
			return
		is_destroyed = true
		for soldier in soldiers:
			soldier.die()
		set_deferred("monitorable", false) # turn off area detection
		$AnimationPlayer.play("destroy")
