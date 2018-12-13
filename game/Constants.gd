extends Node2D

export (float) var PERON_SPEED = 30

export (int) var LASER_PLANE_DAMAGE = 2
export (int) var LASER_SOLDIER_DAMAGE = 3
export (int) var LASER_SOLDIER_BOMB_DAMAGE = 6
export (int) var LASER_CANNON_BOMB_DAMAGE = 4

export (int) var LASER_MAX_CHARGE = 1200
# how much charge the laser consumes and reloads each frame
export (int) var LASER_CHARGE_STEP = 10
export (int) var LASER_RECHARGE_STEP = 13
export (float) var LASER_RECHARGE_DELAY = 2 # seconds

export (float) var FIST_SPEED = 200
export (float) var FIST_GRAVITY = 40
export (float) var FIST_RELOAD_TIME = 10 # seconds

export (float) var PLANE_SPEED = -120
export (int) var PLANE_BOMB_DAMAGE = 5

# how much seconds waits since it's visible to release bomb
export (float) var CANNON_ATTACK_DELAY = 3
export (float) var CANNON_BOMB_SPEED = 60
export (int) var CANNON_BOMB_DAMAGE = 10

export (float) var SOLDIER_BULLET_SPEED = -50
export (int) var SOLDIER_BULLET_DAMAGE = 2