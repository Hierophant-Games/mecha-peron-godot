class_name Bomb
extends Entity

func _ready():
	$BombSprite.show()
	$ExplosionSprite.hide()
	
	$EnemyProjectile.damage = Constants.PLANE_BOMB_DAMAGE
	$EnemyProjectile.velocity = Vector2(Constants.PLANE_SPEED, 0)
