class_name Rocket
extends Entity

func _ready():
	$EnemyProjectile.damage = Constants.SOLDIER_BULLET_DAMAGE
	$EnemyProjectile.velocity = Vector2(Constants.SOLDIER_BULLET_SPEED, (randf() * 10)-5)
