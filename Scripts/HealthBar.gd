extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var health_bar = $HealthBar
export var max_hp = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.max_value = max_hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_hp(hp):
	health_bar.value = hp
