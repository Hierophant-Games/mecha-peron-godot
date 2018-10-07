tool
extends Sprite

const animations = {
	idle = {
		frames = [1],
		frame_rate = 1,
		loop = false,
	},
	walk = {
		frames = [2, 1, 0, 1],
		frame_rate = 5,
		loop = true,
	},
	attack_left_arm = {
		frames = [1],
		frame_rate = 1,
		loop = false,
	},
	attack_right_arm = {
		frames = [3, 4, 5, 6, 7, 8, 9, 10, 9, 8, 7, 6, 5, 4, 3],
		frame_rate = 10,
		loop = false,
	},
	damage = {
		frames = [3],
		frame_rate = 1,
		loop = false,
	},
	laser = {
		frames = [0],
		frame_rate = 1,
		loop = false,
	},
	laser_off = {
		frames = [1],
		frame_rate = 1,
		loop = false,
	}
}

var curr_anim_name = "walk"
var curr_frame = 0
var accum = 0

func animate(anim, delta):
	accum += delta
	
	var frame_duration = 1.0 / anim.frame_rate;
	
	if accum > frame_duration:
		accum -= frame_duration
		if anim.loop:
			curr_frame = (curr_frame + 1) % anim.frames.size()
		else:
			curr_frame = min(curr_frame + 1, anim.frames.size() - 1)
		frame = anim.frames[curr_frame]

func _process(delta):
	animate(animations[curr_anim_name], delta)