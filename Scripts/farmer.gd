extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var face_left = true
const base_speed = 100
var speed = base_speed
var chase_mult = 1.5
var time = 0
var freq = 10
export var max_hp = 10
var hp = max_hp
var knockback_value_vertical = 20
var knockback_value_horizontal = 300
var walkback_chance = 0.8

const is_farmer = true

var knockback_vec = Vector2()

var player = null

var chasing_player = false

var dying = false

export var player_node_string = "/root/Game/Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_node_string)
	$WalkTimer.start()
	got_hit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	# wobble
	time += delta
	global_rotation = Global.wobble(time, freq)
	
	
	var dir_to_player = sign(player.global_position.x - global_position.x) \
		if player != null else 1

	if chasing_player:
		face_left = dir_to_player < 0
	
	var walk_dir = Global.left_dir if face_left else Global.right_dir
	
	if face_left:
		$Sprite.play("left")
	else:
		$Sprite.play("right")
	
	# forces
	var move_vec = walk_dir * speed
	
	var gravity = Vector2(0, Global.gravity)
	
	move_vec += gravity + knockback_vec
	
	var collision = move_and_slide(move_vec)
	
	check_collision_dmg()
	
func got_hit(damage = 0):
	if dying:
		return
	hp -= damage
	$HealthUI.update_hp(hp)
	if hp <= 0:
		dying = true
		$DeathSound.play()

func knockback(left):
	if left:
		knockback_vec.x -= knockback_value_horizontal
	else:
		knockback_vec.x += knockback_value_horizontal
	knockback_vec.y -= knockback_value_vertical 
	$Knockback.start()


func _on_DeathSound_finished():
	queue_free()


func _on_Knockback_timeout():
	knockback_vec = Vector2()
	
func check_collision_dmg():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.get("is_player") == true:
			collision.collider.got_hit_by_farmer(face_left)
			return


func _on_DetectionRange_body_entered(body):
	if body.get("is_player") == true:
		speed = base_speed * chase_mult
		chasing_player = true
		$WalkTimer.stop()



func _on_DetectionRange_body_exited(body):
	if body.get("is_player") == true:
		speed = base_speed
		chasing_player = false
		$WalkTimer.start()



func _on_WalkTimer_timeout():
	if Global.chance(walkback_chance):
		face_left = !face_left
