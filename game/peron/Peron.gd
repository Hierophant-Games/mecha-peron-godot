class_name Peron
extends Area2D

const FistScene = preload("res://game/peron/Fist.tscn")
const LaserScene = preload("res://game/peron/Laser.tscn")

var left_laser: Laser = LaserScene.instantiate() as Laser
var right_laser: Laser = LaserScene.instantiate() as Laser

var blocked: bool = false
var shooting_laser: bool = false
var current_speed: float = 0

var health: int = 100
var laser_charge: int = Constants.LASER_MAX_CHARGE
var laser_recharge_accum: float = 0.0
var laser_overheat: bool = false

var fist_timer: float = 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	setup_laser(left_laser, $LeftEye.position)
	setup_laser(right_laser, $RightEye.position)
	walk()

func setup_laser(new_laser: Laser, laser_position: Vector2):
	add_child(new_laser)
	new_laser.hide()
	new_laser.position = laser_position

func _process(delta: float):
	update_laser(delta)

	fist_timer = max(0.0, fist_timer - delta)
	
	if animation_player.current_animation == "walk":
		position.x += current_speed * delta
	elif animation_player.current_animation == "idle" and !blocked:
		animation_player.play("walk") # makes sure walk is resumed if it got stuck on idle

func get_laser_percentage() -> int:
	@warning_ignore("integer_division")
	return laser_charge * 100 / Constants.LASER_MAX_CHARGE

func get_fist_percentage() -> float:
	return (Constants.FIST_RELOAD_TIME - fist_timer) * 100 / Constants.FIST_RELOAD_TIME

func is_attacking() -> bool:
	return shooting_laser \
		or animation_player.current_animation == "attack_left_arm" \
		or animation_player.current_animation == "attack_right_arm"
		
func update_laser(delta: float) -> void:
	if shooting_laser:
		laser_recharge_accum = 0
		laser_charge -= Constants.LASER_CHARGE_STEP
		if laser_charge <= 0:
			laser_charge = 0
			laser_overheat = true
			laser_off()
	else:
		if laser_overheat:
			laser_recharge_accum += delta
		if !laser_overheat or laser_recharge_accum > Constants.LASER_RECHARGE_DELAY:
			laser_charge += Constants.LASER_RECHARGE_STEP
			if laser_charge >= Constants.LASER_MAX_CHARGE:
				laser_charge = Constants.LASER_MAX_CHARGE
				laser_overheat = false

func play_and_set_next(anim: String):
	animation_player.play(anim)
	animation_player.animation_set_next("attack_left_arm", anim)
	animation_player.animation_set_next("attack_right_arm", anim)

func walk():
	play_and_set_next("walk")

func idle():
	play_and_set_next("idle")

func resume():
	if !blocked:
		walk()
	else:
		idle()

func can_use_fist() -> bool:
	return fist_timer <= 0.0

func attack_fist():
	if can_use_fist():
		animation_player.play("attack_left_arm")

func launch_fist():
	var fist = FistScene.instantiate() as Fist
	fist.position = $FistStart.position
	add_child(fist)
	fist_timer = Constants.FIST_RELOAD_TIME

func attack_arm():
	animation_player.play("attack_right_arm")

func laser():
	shooting_laser = true
	animation_player.play("laser")
	left_laser.on()
	right_laser.on()

func laser_reverse():
	shooting_laser = false
	left_laser.off()
	right_laser.off()
	animation_player.play_backwards("laser")
	await animation_player.animation_finished
	resume()

func laser_off():
	shooting_laser = false
	animation_player.play("laser_off")

func point_laser(pos: Vector2):
	right_laser.look_at(pos)
	right_laser.rotation = clamp(right_laser.rotation, Constants.LASER_ROTATION_MIN, Constants.LASER_ROTATION_MAX)
	left_laser.rotation = right_laser.rotation

func damage(amount: int):
	health = max(0, health - amount)
	animation_player.play("damage")
	await animation_player.animation_finished
	resume()

func _on_AnimationPlayer_animation_started(anim_name: String):
	if anim_name == "walk":
		current_speed = Constants.PERON_SPEED
	else:
		current_speed = 0

func anim_callback_arm_landed():
	var areas = $arm_hit.get_overlapping_areas()
	for area in areas:
		var building = area as FrontBuilding
		if building and building.monitorable:
			building.destroy()

func _on_Peron_area_entered(_area: Area2D):
	blocked = true
	idle()

func _on_Peron_area_exited(_area: Area2D):
	blocked = false
	resume()
