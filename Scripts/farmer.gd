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

const apple_class = preload("res://Scenes/PowerUp/Apple.tscn")
const ammo_class = preload("res://Scenes/PowerUp/AmmoCrate.tscn")

const is_farmer = true

var knockback_vec = Vector2()

var player = null

var chasing_player = false

var dying = false

var jumping = false

var jump_mult = 3

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
	
	if jumping:
		gravity *= -1 * jump_mult
	
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
	if Global.chance(Global.drop_chance):
		spawn_power_up()
	queue_free()

func spawn_power_up():
	if Global.flip_coin():
		spawn_powerup_instance(ammo_class)
	else:
		spawn_powerup_instance(apple_class)

func spawn_powerup_instance(powerup_class):
	var powerup = powerup_class.instance()
	powerup.position = get_position()
	var powerup_node = get_tree().get_root().get_node("Game").get_node("PowerUps")
	if powerup_node != null:
		powerup_node.add_child(powerup)
	else:# something is wrong here
		get_tree().get_root().add_child(powerup)
		print("No powerup node")

func _on_Knockback_timeout():
	knockback_vec = Vector2()
	
func check_collision_dmg():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var body = collision.collider
		if body.get("is_player") == true:
			collision.collider.got_hit_by_farmer(face_left)
		elif knockback_vec != Vector2() and body.get("is_farmer") == true:
			var left = knockback_vec.x < 0
			body.knockback(left)
		elif chasing_player and body.get("is_fence") == true:
			jump()


func _on_DetectionRange_body_entered(body):
	if body.get("is_player") == true:
		speed = base_speed * chase_mult
		chasing_player = true
		$Aware.visible = true
		$WalkTimer.stop()



func _on_DetectionRange_body_exited(body):
	if body.get("is_player") == true:
		speed = base_speed
		chasing_player = false
		$Aware.visible = false
		$WalkTimer.start()



func _on_WalkTimer_timeout():
	if Global.chance(walkback_chance):
		face_left = !face_left

func jump():
	jumping = true
	$JumpTimer.start()


func _on_JumpTimer_timeout():
	jumping = false
