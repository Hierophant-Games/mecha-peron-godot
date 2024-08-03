class_name Constants
extends Node

const GRAVITY := 200.0

const PERON_SPEED := 30.0
const PERON_DYING_SPEED := 6.0 # falling down

const LASER_PLANE_DAMAGE := 2
const LASER_SOLDIER_DAMAGE := 3
const LASER_SOLDIER_BOMB_DAMAGE := 6
const LASER_CANNON_BOMB_DAMAGE := 4

const LASER_MAX_CHARGE := 1200
# how much charge the laser consumes and reloads each frame
const LASER_CHARGE_STEP := 10
const LASER_RECHARGE_STEP := 13
const LASER_RECHARGE_DELAY := 2.0 # seconds
const LASER_ROTATION_MIN := deg_to_rad(-15)
const LASER_ROTATION_MAX := deg_to_rad(45)

const FIST_SPEED := 200.0
const FIST_GRAVITY := GRAVITY * 0.25
const FIST_RELOAD_TIME := 10.0 # seconds

const PLANE_SPEED := -120.0
const PLANE_BOMB_DAMAGE := 5
const PLANE_GRAVITY := 140.0

# how many seconds waits since it's visible to release bomb
const CANNON_ATTACK_DELAY := 3.0
const CANNON_BOMB_SPEED := 60.0
const CANNON_BOMB_DAMAGE := 10

const SOLDIER_BULLET_SPEED := -50.0
const SOLDIER_BULLET_DAMAGE := 2
const SOLDIER_SHOOT_TIME := 6.0 # seconds

const DELETION_THRESHOLD_MODIFIER := Vector2(2, 2)
