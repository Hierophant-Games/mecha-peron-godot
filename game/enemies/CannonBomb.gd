class_name CannonBomb
extends Entity

@onready var target := get_tree().current_scene.peron as Area2D

func fly():
	var projectile := $EnemyProjectile as EnemyProjectile
	projectile.damage = Constants.CANNON_BOMB_DAMAGE
	
	var target_size := (target.shape_owner_get_shape(0, 0) as RectangleShape2D).size
	var target_pos := target.global_position - Vector2(0, target_size.y)
	
	projectile.velocity = (target_pos - global_position).normalized() * Constants.CANNON_BOMB_SPEED

func on_destroy_invoked() -> void:
	$AudioStreamPlayer.play()
