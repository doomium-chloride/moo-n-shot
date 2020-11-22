extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const is_player = true

const base_speed = 300
const bullet_class = preload("res://Actors/bullet.tscn")

export var max_hp = 10
var hp = max_hp

var speed = base_speed
var face_left = true
var cow_radius = 100
var barrel_pos = 10
var max_ammo = 11
var ammo = max_ammo
var jump_speed = 10

var shell_shots = 5

var is_moving = false
var is_pumping = false
var grounded = false
var jumping = false

var knockback_vec = Vector2()
var knockback_value = Global.gravity
var jump_mult = 6
var recoil_vec = Vector2()

var recoiling = false
var invulnerable = false

onready var background = get_node("/root/Game/Backgroud")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.emit_signal("set_max_ammo", max_ammo)
	Global.emit_signal("set_ammo_spacing", 50)
	hp = max_hp
	Global.emit_signal("set_max_hp", max_hp)
	Global.emit_signal("update_hp", hp)
	$Sprite.animation = "still"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("ui_select"):
		shoot_bullet(get_bullet_pos())
	if Input.is_action_just_pressed("ui_down"):
		reload()
	if Input.is_action_just_pressed("ui_shift"):
		shell_shots += 10
	
func cow_face_left(left):
	if left:
		get_node( "Sprite" ).set_flip_h( false )
		face_left = true
	else:
		get_node( "Sprite" ).set_flip_h( true )
		face_left = false
		
func shoot_bullet(pos = position):
	if gun_busy():
		return
	if ammo > 0:
		ammo -= 1
		check_recoil()
		shoot_shots(pos, shell_shots)
		$GunSound.play()
		Global.emit_signal("update_ammo", ammo)
		is_pumping = true
	else:
		if not $EmptyGun.playing:
			$EmptyGun.play()

func shoot_1_shot(pos):
	var bullet = bullet_class.instance()
	bullet.damage = Global.bullet_damage
	bullet.velocity = Global.bullet_spread(face_left)
	bullet.position = pos
	get_tree().get_root().add_child(bullet)

func shoot_shots(pos, shots = 5):
	for i in range(shots):
		shoot_1_shot(pos)
		if recoiling:
			recoil()

func reload():
	if gun_busy():
		return
	if ammo >= max_ammo:
		ammo = max_ammo
	else:
		ammo += 1
		$ReloadGun.play()
	Global.emit_signal("update_ammo", ammo)

func gun_busy():
	return $ReloadGun.playing or $GunSound.playing

func get_bullet_pos():
	var pos = get_position()
	pos.y += barrel_pos
	if face_left:
		pos.x -= cow_radius
	else:
		pos.x += cow_radius
	return pos

func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("ui_left"):
		move_vec.x -= 1
		cow_face_left(true)
	if Input.is_action_pressed("ui_right"):
		move_vec.x += 1
		cow_face_left(false)
	if Input.is_action_just_pressed("ui_up") and grounded:
		jumping = true
		$JumpSound.play()
	
	
	
	move_vec = move_vec * speed
	
	var gravity = Vector2(0, Global.gravity)
	
	if invulnerable:
		move_vec += knockback_vec
	if recoiling:
		move_vec += recoil_vec
	if jumping:
		move_vec -= gravity * jump_mult
	else:
		move_vec += gravity
	
	move_vec = move_and_slide(move_vec)
	
	is_moving = abs(move_vec.x) > 1
	grounded = abs(move_vec.y) < 1
	
	set_anim()
	if background != null:
		background.position.x = position.x

func check_keys():
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_released("ui_left") \
		or Input.is_action_just_pressed("ui_right") or Input.is_action_just_released("ui_right"):
			pass

func set_anim():
	var anim
	if is_pumping:
		anim = "pump"
	elif is_moving:
		anim = "walk"
	else:
		anim = "still"
	$Sprite.play(anim)

func _on_GunSound_finished():
	is_pumping = false


func _on_JumpSound_finished():
	jumping = false

func take_damage(dmg):
	hp -= dmg
	Global.emit_signal("update_hp", hp)
	if not $MooSoud.playing:
		$MooSoud.play()

func heal(healing):
	if hp >= max_hp:
		return false
	hp += healing
	Global.emit_signal("update_hp", hp)
	if not $AppleCrunch.playing:
		$AppleCrunch.play()
	return true

func got_hit_by_farmer(left):
	if not invulnerable:
		$Sprite.modulate = Color(10,10,10)
		$Flash.start()
		knockback(left)
		take_damage(Global.trident_dmg)
		invulnerable = true
		$Invulnerability.start()


func knockback(left):
	if left:
		knockback_vec.x -= knockback_value
	else:
		knockback_vec.x += knockback_value
	knockback_vec.x *= 2
	knockback_vec.y -= knockback_value


func _on_Invulnerability_timeout():
	knockback_vec = Vector2()
	invulnerable = false


func _on_Flash_timeout():
	$Sprite.modulate = Color(1,1,1)

func check_recoil():
	if not grounded:
		recoiling = true
		$Recoil.start()

func recoil():
	# move backwards
	if face_left:
		recoil_vec.x += knockback_value
	else:
		recoil_vec.x -= knockback_value

func _on_Recoil_timeout():
	recoiling = false
	recoil_vec = Vector2()
