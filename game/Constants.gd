class_name Constants
extends Node

const GRAVITY: float = 200.0

const PERON_SPEED: float = 30.0

const LASER_PLANE_DAMAGE: int = 2
const LASER_SOLDIER_DAMAGE: int = 3
const LASER_SOLDIER_BOMB_DAMAGE: int = 6
const LASER_CANNON_BOMB_DAMAGE: int = 4

const LASER_MAX_CHARGE: int = 1200
# how much charge the laser consumes and reloads each frame
const LASER_CHARGE_STEP: int = 10
const LASER_RECHARGE_STEP: int = 13
const LASER_RECHARGE_DELAY: float = 2.0 # seconds
const LASER_ROTATION_MIN: float = deg_to_rad(-15)
const LASER_ROTATION_MAX: float = deg_to_rad(45)

const FIST_SPEED: float = 200.0
const FIST_GRAVITY: float = GRAVITY * 0.25
const FIST_RELOAD_TIME: float = 10.0 # seconds

const PLANE_SPEED: float = -120.0
const PLANE_BOMB_DAMAGE: int = 5
const PLANE_GRAVITY: float = 140.0

# how many seconds waits since it's visible to release bomb
const CANNON_ATTACK_DELAY: float = 3.0
const CANNON_BOMB_SPEED: float = 60.0
const CANNON_BOMB_DAMAGE: int = 10

const SOLDIER_BULLET_SPEED: float = -50.0
const SOLDIER_BULLET_DAMAGE: int = 2

const DELETION_THRESHOLD_MODIFIER: Vector2 = Vector2(2, 2)
