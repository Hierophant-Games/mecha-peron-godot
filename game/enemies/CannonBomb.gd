class_name CannonBomb
extends Entity

var target: Area2D

func _ready():
	target = get_tree().current_scene.peron

func fly():
	var projectile := $EnemyProjectile as EnemyProjectile
	projectile.damage = Constants.CANNON_BOMB_DAMAGE
	
	var target_size := (target.shape_owner_get_shape(0, 0) as RectangleShape2D).size
	var target_pos := target.global_position - Vector2(0, target_size.y)
	
	projectile.velocity = (target_pos - global_position).normalized() * Constants.CANNON_BOMB_SPEED
