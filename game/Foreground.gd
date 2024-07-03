class_name Foreground
extends Node2D

var FrontBuildingScene = preload("res://game/FrontBuilding.tscn")

@onready var next_building_spawn_pos_x = random_offset()
var should_spawn_cannon = false

func update_buildings(screen_right):
	while next_building_spawn_pos_x < screen_right:
		var new_building: FrontBuilding = create_building()
		add_child(new_building)
		if should_spawn_cannon:
			new_building.spawn_cannon()
			should_spawn_cannon = false
		next_building_spawn_pos_x += new_building.width + random_offset()

func create_building() -> FrontBuilding:
	var building: FrontBuilding = FrontBuildingScene.instantiate() as FrontBuilding
	building.position.y = get_viewport_rect().size.y
	building.position.x = next_building_spawn_pos_x
	return building

func random_offset() -> int:
	return 20 + randi() % 20

func prepare_cannon():
	should_spawn_cannon = true
