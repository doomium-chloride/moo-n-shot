extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var velocity = Vector2()
export var damage = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not 	get_node("VisibilityNotifier2D").is_on_screen():
		queue_free()
func _physics_process(delta):
	translate(velocity * delta)

func get_left():
	return velocity.x < 0

func _on_Bullet_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.has_method("got_hit"):
		body.got_hit(damage)
	if body.has_method("knockback"):
		body.knockback(get_left())
	if not body.get("dying") == true:
		queue_free()
