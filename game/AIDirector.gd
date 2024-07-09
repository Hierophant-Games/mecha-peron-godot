extends Node2D

signal enemy_needed

# position to switch difficulty level
const POS_THRESHOLDS = [1000, 2000, 3000]

const ENEMY_CONFIG = {
	plane = {
		pos_between = [200, 150, 100, 50],
		random_tweak = 50
	},
	building = {
		pos_between = [400, 300, 250, 150],
		random_tweak = 50
	},
	cannon = {
		pos_between = [500, 300, 200, 100],
		random_tweak = 100
	}
}

var last_pos = {
	plane = -150,
	building = 0,
	cannon = 0,
}

func _process(_delta):
	var x = -get_canvas_transform().get_origin().x
	var diff_level = get_difficulty_level(x)
	check_enemy("plane", x, diff_level)
	check_enemy("building", x, diff_level)
	check_enemy("cannon", x, diff_level)

func check_enemy(enemy_type, x, diff_level):
	var config = ENEMY_CONFIG[enemy_type]
	if x - last_pos[enemy_type] > config.pos_between[diff_level]:
		last_pos[enemy_type] = x + randi() % config.random_tweak
		enemy_needed.emit(enemy_type, last_pos[enemy_type])

func get_difficulty_level(x):
	var diff_level = 0
	for threshold in POS_THRESHOLDS:
		if x > threshold:
			diff_level += 1
	return diff_level
