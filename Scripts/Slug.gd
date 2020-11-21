extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func shoot():
	$Sprite.modulate = Color(0.1, 0.1, 0.1)

func reload():
	$Sprite.modulate = Color(1, 1, 1)
