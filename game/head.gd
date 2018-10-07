tool
extends Sprite

const animations = {
	idle = {
		frames = [0],
		frame_rate = 1,
		loop = false,
	},
	walk = {
		frames = [0, 1, 2, 1],
		frame_rate = 5,
		loop = true,
	},
	attack_left_arm = {
		frames = [1, 2, 3, 2, 1, 2],
		frame_rate = 4,
		loop = false,
	},
	attack_right_arm = {
		frames = [1, 2, 3, 2, 1, 2],
		frame_rate = 4,
		loop = false,
	},
	damage = {
		frames = [1, 2, 3, 4, 3, 2, 1, 2, 3, 2, 1, 2, 3, 2, 1, 0],
		frame_rate = 16,
		loop = false,
	},
	laser = {
		frames = [1, 5, 6],
		frame_rate = 9,
		loop = false,
	},
	laser_off = {
		frames = [5, 6, 1],
		frame_rate = 9,
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