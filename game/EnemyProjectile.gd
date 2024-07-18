class_name EnemyProjectile
extends Destroyable

@export var velocity: Vector2
@export var gravity: float = Constants.GRAVITY
@export var damage: int

func _ready():
	area_2d.area_entered.connect(_on_area_entered)

func _process(delta):
	if owner.destroyed:
		return
	
	velocity.y += gravity * delta
	owner.position += velocity * delta

func _on_area_entered(area):
	if area.owner is Peron:
		area.owner.damage(damage)
	destroy()
