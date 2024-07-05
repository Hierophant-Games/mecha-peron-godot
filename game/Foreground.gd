class_name Foreground
extends Node2D

var FrontBuildingScene = preload("res://game/FrontBuilding.tscn")

@onready var next_building_spawn_pos_x = random_offset()
var should_spawn_cannon = false
@export var building_textures: Array[Texture2D]
var last_texture_path = ""

func update_buildings(screen_right):
	while next_building_spawn_pos_x < screen_right:
		var new_building: FrontBuilding = create_building()
		add_child(new_building)
		
		# pick random texture while ensuring no repeats
		var available_textures: Array[Texture2D] = building_textures.filter(is_valid_texture_name)
		var texture: Texture2D = available_textures.pick_random()
		last_texture_path = texture.resource_path
		
		# setup building
		new_building.setup(texture, should_spawn_cannon)
		
		# if spawning a cannon, we don't need to do so for a while
		if should_spawn_cannon:
			should_spawn_cannon = false
			
		# set next spawn position
		next_building_spawn_pos_x += new_building.width + random_offset()

func is_valid_texture_name(texture: Texture2D):
	return texture.resource_path != last_texture_path

func create_building() -> FrontBuilding:
	var building: FrontBuilding = FrontBuildingScene.instantiate() as FrontBuilding
	building.position.y = get_viewport_rect().size.y
	building.position.x = next_building_spawn_pos_x
	return building

func random_offset() -> int:
	return 20 + randi() % 20

func prepare_cannon():
	should_spawn_cannon = true
