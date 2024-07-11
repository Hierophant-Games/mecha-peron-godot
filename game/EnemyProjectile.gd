class_name EnemyProjectile
extends Destroyable

@export var velocity: Vector2
@export var gravity: float = Constants.GRAVITY

func _ready():
	area_2d.area_entered.connect(_on_area_entered)

func _process(delta):
	if owner.get_meta("destroyed"):
		return
	
	velocity.y += gravity * delta
	owner.position += velocity * delta

func _enter_tree():
	assert(owner is Node2D, "Owner must be Node2D")

func _on_area_entered(area):
	if area.owner is Peron:
		area.owner.damage()
	destroy()
