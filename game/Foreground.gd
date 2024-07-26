class_name Foreground
extends Node2D

var FrontBuildingScene := preload("res://game/FrontBuilding.tscn")

@onready var next_building_spawn_pos_x := random_offset()
@export var building_textures: Array[Texture2D]

var last_texture_path := ""
var should_spawn_cannon := false

func update_buildings(screen_right: int) -> void:
	while next_building_spawn_pos_x < screen_right:
		var new_building := create_building()
		add_child(new_building)
		
		# pick random texture while ensuring no repeats
		var available_textures := building_textures.filter(is_valid_texture_name)
		var texture := available_textures.pick_random() as Texture2D
		last_texture_path = texture.resource_path
		
		# setup building
		new_building.setup(texture, should_spawn_cannon)
		
		# if spawning a cannon, we don't need to do so for a while
		if should_spawn_cannon:
			should_spawn_cannon = false
			
		# set next spawn position
		next_building_spawn_pos_x += new_building.width + random_offset()

func is_valid_texture_name(texture: Texture2D) -> bool:
	return texture.resource_path != last_texture_path

func create_building() -> FrontBuilding:
	var building := FrontBuildingScene.instantiate() as FrontBuilding
	building.position.y = get_viewport_rect().size.y
	building.position.x = next_building_spawn_pos_x
	return building

func random_offset() -> int:
	return 20 + randi() % 20

func prepare_cannon() -> void:
	should_spawn_cannon = true
