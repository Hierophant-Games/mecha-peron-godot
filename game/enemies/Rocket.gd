class_name Rocket
extends Entity

func _ready():
	var projectile = $EnemyProjectile as EnemyProjectile
	projectile.damage = Constants.SOLDIER_BULLET_DAMAGE
	projectile.velocity = Vector2(Constants.SOLDIER_BULLET_SPEED, (randf() * 10)-5)
