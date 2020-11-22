extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var period = 5
var farmer_class = load("res://Actors/farmer.tscn")
onready var spawn_pos = get_position() + Vector2(0, -100)
export var max_hp = 200
var hp = max_hp

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = max_hp
	$HealthUI.update_hp(hp)
	$Timer.wait_time = period
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_shift"):
		#spawn_farmer()
		pass
		
func spawn_farmer():
	var farmer = farmer_class.instance()
	farmer.position = spawn_pos
	$Container.add_child(farmer)


func _on_Timer_timeout():
	spawn_farmer()

func got_hit(dmg):
	hp -= dmg
	$HealthUI.update_hp(hp)
