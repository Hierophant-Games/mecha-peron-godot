class_name Level
extends Node2D

const AirplaneScene = preload("res://game/enemies/Airplane.tscn")
const EnemyBuildingScene = preload("res://game/enemies/EnemyBuilding.tscn")

enum { PRE_INTRO, INTRO, POST_INTRO }
var intro_state := PRE_INTRO

@export_file("*.tscn") var main_menu_scene: String

@onready var main_layer := $ParallaxBackground/MainLayer
@onready var front_layer := $ParallaxBackground/FrontLayer as Parallax2D
@onready var foreground := $ParallaxBackground/FrontLayer/Foreground as Foreground
@onready var peron := $ParallaxBackground/MainLayer/Peron as Peron
@onready var camera := $ParallaxBackground/MainLayer/Peron/Camera2D as Camera2D
@onready var hud := $GUILayer/HUD as HUD
@onready var init_screen := $GUILayer/InitScreen as InitScreen
@onready var game_over := $GUILayer/GameOver as GameOver
@onready var scene_fader := $GUILayer/SceneFader as SceneFader

func _ready() -> void:
	GlobalAudio.stop_music()
	ScoreTracker.reset()
	hud.hide()
	init_screen.hide()
	game_over.hide()

func _process(_delta: float):
	update_intro()
	update_foreground()

	if intro_state != POST_INTRO:
		return

	var distance := peron.position.x
	ScoreTracker.set_distance(distance)
	input()
	
	if !game_over.visible and peron.dying:
		game_over.show()

func update_intro():
	match intro_state:
		PRE_INTRO:
			camera.global_position.x = global_position.x
			if Input.is_action_just_pressed("ui_accept"):
				Engine.time_scale = 4;
			if peron.position.x > 0:
				intro_state = INTRO
				Engine.time_scale = 1
				peron.blocked = true
				peron.idle()
				init_screen.show()
		INTRO:
			# The InitScreen auto-hides when done, that's our cue to continue
			if !init_screen.visible:
				intro_state = POST_INTRO
				peron.blocked = false
				peron.walk()
				init_screen.hide()
				hud.show()
				GlobalAudio.play_ingame_music()

func input():
	if peron.dying:
		return

	# CHEATS
	if OS.has_feature('debug'):
		if Input.is_key_pressed(KEY_G):
			peron.health = 0

	var shoot_laser_pressed := Input.is_action_pressed("shoot_laser")

	if peron.shooting_laser:
		if shoot_laser_pressed:
			peron.aim_laser()
		else:
			peron.laser_reverse()

	if peron.is_attacking():
		return
	
	if Input.is_action_just_pressed("attack_fist"):
		peron.attack_fist()
		return
	elif Input.is_action_just_pressed("attack_arm"):
		peron.attack_arm()
		return
	if shoot_laser_pressed:
		laser()

func laser():
	peron.laser()
	peron.aim_laser()

func update_foreground():
	var screen_right := (camera.global_position.x + get_viewport_rect().size.x) * front_layer.scroll_scale.x
	foreground.update_buildings(int(screen_right))

func _on_AIDirector_enemy_needed(enemy_type: String, x: float):
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
