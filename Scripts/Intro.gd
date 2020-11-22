extends "res://Scripts/Monologue.gd"


func _ready():
	next_scene = "res://Scenes/Game.tscn"
	text_array = [
		"Beef demand has skyrocketed",
		"blah blah insert story",
		"game starting..."
	]
	init()
