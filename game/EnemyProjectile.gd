class_name EnemyProjectile
extends Destroyable

@export var velocity: Vector2 = Vector2()

func _ready():
	area_2d.area_entered.connect(self._on_area_entered)

func _process(delta):
	if owner.get_meta("destroyed", false):
		return
	owner.position += Vector2(velocity.x * delta, (velocity.y + Constants.GRAVITY) * delta)

func _enter_tree():
	assert(owner is Node2D, "Owner must be Node2D")

func _on_area_entered(area):
	if area.owner is Peron:
		area.owner.damage()
	destroy()
