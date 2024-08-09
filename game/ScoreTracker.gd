extends Node

enum EnemyType {
	PLANE,
	BUILDING,
	SOLDIER,
	CANNON
}

const ENEMY_NAMES := ["Plane", "Building", "Soldier", "Cannon"]
const SCORE_VALUES:Array[int] = [10, 20, 1, 20];
const DISTANCE_SCALE_FACTOR = 300

var score := 0:
	get:
		return score

var killedCount:Array[int] = [0, 0, 0, 0]:
	get:
		return killedCount
		
var distanceTraveled:float = 0:
	get:
		return distanceTraveled

func reset():
	killedCount = [0, 0, 0, 0]
	score = 0
	if OS.has_feature('debug'):
			print("Score was reset!")

func track_killed(type: EnemyType):
	killedCount[type] += 1;
	score += SCORE_VALUES[type];
	if OS.has_feature('debug'):
			print("Score: ", score, " total ", ENEMY_NAMES[type], "(s) killed: ", killedCount[type])

func set_distance(value: float):
	distanceTraveled = (value / DISTANCE_SCALE_FACTOR)
