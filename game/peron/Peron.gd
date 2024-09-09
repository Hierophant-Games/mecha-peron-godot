class_name Peron
extends Area2D

const FistScene := preload("res://game/peron/Fist.tscn")
const LaserScene := preload("res://game/peron/Laser.tscn")
const ExplosionScene := preload("res://game/vfx/Explosion.tscn")

@export var hit_sounds: Array[AudioStream]
@export var phrases: Array[AudioStream]
@export var sfx_laser_shoot: AudioStream
@export var sfx_laser_depleted: AudioStream
@export var sfx_laser_shout: AudioStream
@export var sfx_rocket_punch: AudioStream
@export var sfx_hammer_fist: AudioStream

var left_laser := LaserScene.instantiate() as Laser
var right_laser := LaserScene.instantiate() as Laser

var blocked := false
var shooting_laser := false
var dying := false

var current_speed := 0.0

var health := 100
var laser_charge := Constants.LASER_MAX_CHARGE
var laser_recharge_accum := 0.0
var laser_overheat := false

var fist_timer := 0.0

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var smoke_emitters : Array[CPUParticles2D] = [$RightEye/SmokeEmitter, $LeftEye/SmokeEmitter]

# Sound effects and players ------------
@onready var laser_sfx_player := $SFX/Laser as AudioStreamPlayer
@onready var voice_sfx_player := $SFX/Voice as AudioStreamPlayer

func _ready() -> void:
	setup_laser(left_laser, $LeftEye.position)
	setup_laser(right_laser, $RightEye.position)
	walk()

func setup_laser(new_laser: Laser, laser_position: Vector2):
	add_child(new_laser)
	new_laser.hide()
	new_laser.position = laser_position

func _process(delta: float):
	if !dying and health <= 0:
		dying = true
		idle()
		VFX.shake(0.01, 100)
		$DyingExplosionsTimer.start()
	
	if dying:
		position.y += Constants.PERON_DYING_SPEED * delta
		return
	
	update_laser(delta)
	
	fist_timer = max(0.0, fist_timer - delta)
	
	if animation_player.current_animation == "walk":
		position.x += current_speed * delta
	elif animation_player.current_animation == "idle" and !blocked:
		walk()

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
			laser_sfx_player.set_stream(sfx_laser_depleted)
			laser_sfx_player.play()
			for emitter in smoke_emitters:
				emitter.emitting = true
			laser_off()
	else:
		if laser_overheat:
			laser_recharge_accum += delta
		if !laser_overheat or laser_recharge_accum > Constants.LASER_RECHARGE_DELAY:
			laser_charge += Constants.LASER_RECHARGE_STEP
			if laser_charge >= Constants.LASER_MAX_CHARGE:
				laser_charge = Constants.LASER_MAX_CHARGE
				laser_overheat = false
				for emitter in smoke_emitters:
					emitter.emitting = false

func play_and_set_next(anim: String):
	animation_player.play(anim)
	animation_player.animation_set_next("attack_left_arm", anim)
	animation_player.animation_set_next("attack_right_arm", anim)

func walk():
	$StepTimer.start()
	$TalkTimer.set_paused(false)
	play_and_set_next("walk")

func idle():
	$StepTimer.stop()
	$TalkTimer.set_paused(true)
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
		voice_sfx_player.set_stream(sfx_rocket_punch)
		voice_sfx_player.play()

func launch_fist():
	var fist = FistScene.instantiate() as Fist
	fist.position = $FistStart.position
	add_child(fist)
	fist_timer = Constants.FIST_RELOAD_TIME

func attack_arm():
	animation_player.play("attack_right_arm")
	voice_sfx_player.set_stream(sfx_hammer_fist)
	voice_sfx_player.play()

func laser():
	if laser_overheat:
		laser_off()
		return
	
	shooting_laser = true
	animation_player.play("laser")
	voice_sfx_player.set_stream(sfx_laser_shout)
	voice_sfx_player.play()
	laser_sfx_player.set_stream(sfx_laser_shoot)
	laser_sfx_player.play()
	left_laser.on()
	right_laser.on()
	VFX.flash(Color(Color.WHITE, 0.4), 0.5)

func laser_reverse():
	shooting_laser = false
	left_laser.off()
	right_laser.off()
	animation_player.play_backwards("laser")
	if laser_sfx_player.stream == sfx_laser_shoot:
		laser_sfx_player.stop()
	await animation_player.animation_finished
	resume()

func laser_off():
	shooting_laser = false
	left_laser.off()
	right_laser.off()
	animation_player.play("laser_off")
	await animation_player.animation_finished
	resume()

func aim_laser():
	right_laser.look_at(get_global_mouse_position())
	right_laser.rotation = clamp(right_laser.rotation, Constants.LASER_ROTATION_MIN, Constants.LASER_ROTATION_MAX)
	left_laser.rotation = right_laser.rotation

func damage(amount: int):
	health = max(0, health - amount)
	
	# don't interrupt attacks or dying
	if animation_player.current_animation != "walk":
		return
	
	animation_player.play("damage")
	voice_sfx_player.set_stream(hit_sounds.pick_random())
	voice_sfx_player.play()
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

func _on_step_timer_timeout() -> void:
	VFX.shake(0.01, 0.2)
	$SFX/FootStep.play()
	
func _on_talk_timer_timeout() -> void:
	voice_sfx_player.set_stream(phrases.pick_random())
	voice_sfx_player.play()

func _on_dying_explosions_timer_timeout() -> void:
	var spawn_area_size := ($DamageArea as Area2D).shape_owner_get_shape(0, 0).get_rect().size
	var x := randf_range(0, spawn_area_size.x)
	var y := randf_range((spawn_area_size.y * 0.5), spawn_area_size.y) #take top half only
	var explosion := ExplosionScene.instantiate()
	explosion.position = Vector2(x, -y)
	add_child(explosion)
