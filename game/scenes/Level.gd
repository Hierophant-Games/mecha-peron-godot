class_name Level
extends Node2D

const AirplaneScene = preload("res://game/enemies/Airplane.tscn")
const EnemyBuildingScene = preload("res://game/enemies/EnemyBuilding.tscn")

enum { PRE_INTRO, INTRO, POST_INTRO }
var intro_state := PRE_INTRO

@export_file("*.tscn") var main_menu_scene: String

@onready var main_layer := $Camera2D/ParallaxBackground/MainLayer
@onready var front_layer := $Camera2D/ParallaxBackground/FrontLayer
@onready var foreground := $Camera2D/ParallaxBackground/FrontLayer/Foreground
@onready var peron := $Camera2D/ParallaxBackground/MainLayer/Peron as Peron
@onready var camera := $Camera2D
@onready var scene_fader := $GUILayer/SceneFader as SceneFader
@onready var game_over := $GUILayer/GameOver as GameOver

func _ready() -> void:
	game_over.hide()

func _process(_delta: float):
	update_intro()
	update_foreground()

	if intro_state != POST_INTRO:
		return

	camera.position.x = peron.position.x
	input()
	
	if !game_over.visible and peron.dying:
		game_over.show()

func update_intro():
	match intro_state:
		PRE_INTRO:
			if peron.position.x > 0:
				intro_state = INTRO
				Engine.time_scale = 1
				peron.idle()
			if Input.is_action_just_pressed("ui_accept"):
				Engine.time_scale = 4;
		INTRO:
			if Input.is_action_just_pressed("ui_accept"):
				intro_state = POST_INTRO
				Engine.time_scale = 1
				peron.walk()

func input():
	if peron.dying:
		return
	
	var mouse_pressed := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if peron.shooting_laser:
		if mouse_pressed:
			rotate_laser()
		else:
			end_laser()

	if peron.is_attacking():
		return
	
	if Input.is_action_just_pressed("attack_fist"):
		peron.attack_fist()
	if Input.is_action_just_pressed("attack_arm"):
		peron.attack_arm()
	if mouse_pressed:
		laser()
	
	# CHEATS
	if OS.has_feature('debug'):
		if Input.is_key_pressed(KEY_G):
			peron.health = 0

func laser():
	peron.laser()
	rotate_laser()

func end_laser():
	peron.laser_reverse()

func rotate_laser():
	peron.point_laser(get_viewport().get_mouse_position())

func update_foreground():
	var screen_right = (camera.position.x + get_viewport_rect().size.x) *  front_layer.motion_scale.x
	foreground.update_buildings(screen_right)

func _on_AIDirector_enemy_needed(enemy_type, x):
	match enemy_type:
		"plane":
			spawn_plane(x)
		"building":
			spawn_building(x)
		"cannon":
			foreground.prepare_cannon()

func spawn_plane(x: float):
	var plane: Airplane = AirplaneScene.instantiate() as Airplane
	plane.position.x = get_viewport_rect().size.x + x
	main_layer.add_child(plane)

func spawn_building(x: float):
	var enemy_building: EnemyBuilding = EnemyBuildingScene.instantiate() as EnemyBuilding
	enemy_building.position.y = get_viewport_rect().size.y
	enemy_building.position.x = get_viewport_rect().size.x + x
	main_layer.add_child(enemy_building)

func _on_game_over_main_menu_pressed() -> void:
	scene_fader.transition_to(main_menu_scene)

func _on_game_over_try_again_pressed() -> void:
	get_tree().reload_current_scene()
