class_name Fist
extends Area2D

var distance = 0.0
var vel_y = 0.0

# we need to reset these values each time the node is added to the scene
func _enter_tree():
	distance = 0
	vel_y = 0

func _process(delta):
	vel_y += Constants.FIST_GRAVITY * delta
	distance += Constants.FIST_SPEED * delta
	position.x += Constants.FIST_SPEED * delta
	position.y += vel_y * delta

func _on_area_entered(area):
	var enemy_building = area.owner as EnemyBuilding
	if enemy_building:
		for soldier in enemy_building.soldiers:
			soldier.die()
		enemy_building.get_meta("destroyable").destroy()
	queue_free()
