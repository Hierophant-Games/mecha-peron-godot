extends Area2D

class_name EnemyBuilding

const Soldier = preload("res://game/enemies/Soldier.tscn")

const MIN_SOLDIERS = 8
const MAX_ADDITIONAL_SOLDIERS = 8

var soldiers: Array = []

func _enter_tree():
	$Sprite.frame = 0
	populate()

func populate():
	var soldierCount = randi() % MAX_ADDITIONAL_SOLDIERS + MIN_SOLDIERS
	for i in soldierCount:
		var soldier = Soldier.instance()
		soldiers.append(soldier)

	var i = 0
	for node in getRandomSpawnPoints(soldierCount):
		node.add_child(soldiers[i])
		i+=1

func getRandomSpawnPoints(count):
	var spawnPoints = $SpawnArea.get_children()
	spawnPoints.shuffle()
	return spawnPoints.slice(0, count-1)

func kill():
	for soldier in soldiers:
		soldier.get_parent().remove_child(soldier)
		soldier.free()
	soldiers.clear()
	get_parent().remove_child(self)

func _on_EnemyBuilding_area_entered(area):
	if area as Fist:
		for soldier in soldiers:
			soldier.die()
		$AnimationPlayer.play("destroy")
