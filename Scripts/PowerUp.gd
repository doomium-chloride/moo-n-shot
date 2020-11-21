extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const is_powerup = true

func _ready():
	$Area2D.connect("body_entered", self, "check_if_player")
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(1, true)
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)

func _physics_process(delta):
	var gravity = Vector2(0, Global.gravity)
	gravity = move_and_slide(gravity)
	check_collision()

func check_collision():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if check_if_player(collision.collider):
			return

func check_if_player(body):
	if body.get("is_player") == true:
		power_up(body)
		return true
	return false

func power_up(player):
	pass
