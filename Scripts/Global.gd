extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var gravity = 100

var bullet_speed = 1000

var bullet_damage = 1

var base_bullet_spread = PI / 100

var trident_dmg = 1

const left_dir = Vector2(-1, 0)
const right_dir = Vector2(1, 0)

signal update_hp(hp)
signal set_max_hp(hp)

signal update_ammo(ammo)
signal set_max_ammo(ammo)
signal set_ammo_spacing(spacing)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func wobble(t, freq):
	return sin(t * freq) * PI / 32

func flip_coin():
	var coin = randi() % 2
	return coin == 0

func chance(proc_chance):
	if proc_chance >= 1:
		return true
	return randf() < proc_chance

func bullet_spread(left):
	var angle = randf() * base_bullet_spread
	var dir = -1 if left else 1
	var up = -1 if flip_coin() else 1
	return Vector2(dir * cos(angle) * bullet_speed, up * sin(angle) * bullet_speed)
	pass
