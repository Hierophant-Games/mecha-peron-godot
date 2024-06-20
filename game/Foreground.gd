extends Node2D

class_name Foreground

const FrontBuilding = preload("res://game/FrontBuilding.tscn")

var Pool = load("res://addons/godot-object-pool/pool.gd")
onready var pool = Pool.new(10, "front_building", FrontBuilding)

var last_building_pos = 0

func _ready():
	pool.add_to_node(self)

func update_building_pool(screen_left, screen_right):
	# first kill the buildings that are no longer in screen
	for building in get_children():
		if building.position.x + building.width < screen_left:
			building.kill()
	
	# then add buildings if needed
	while last_building_pos < screen_right:
		var building = pool.get_first_dead()
		if !building:
			break
		building.position.x = last_building_pos
		building.position.y = get_viewport_rect().size.y
		var random_offset = 20 + randi() % 20
		last_building_pos += building.width + random_offset
