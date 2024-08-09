extends Node

enum EnemyType {
	PLANE,
	BUILDING,
	SOLDIER,
	CANNON
}

const ENEMY_NAMES := ["Plane", "Building", "Soldier", "Cannon"]
const SCORE_VALUES := [10, 20, 1, 20]
const DISTANCE_SCALE_FACTOR := 300.0

var _score := 0
var _killed_count := [0, 0, 0, 0]
var _distance_traveled := 0.0
var _interpolated_score := 0.0

func reset():
	_killed_count = [0, 0, 0, 0]
	_score = 0
	_distance_traveled = 0.0
	if OS.has_feature('debug'):
		print("Score was reset!")

func track_killed(type: EnemyType):
	_killed_count[type] += 1;
	_score += SCORE_VALUES[type];
	if OS.has_feature('debug'):
		print("Score: ", _score, " total ", ENEMY_NAMES[type], "(s) killed: ", _killed_count[type])

func set_distance(value: float):
	_distance_traveled = value / DISTANCE_SCALE_FACTOR

func get_distance_text() -> String:
	return str(_distance_traveled).pad_decimals(2) + " km"

func get_score_text() -> String:
	return str("Total Destruction: ", _score)

func get_interpolated_score_text(delta: float) -> String:
	_interpolated_score = minf(_score, _interpolated_score + delta * 10)
	return str("Destruction: ", int(_interpolated_score))
