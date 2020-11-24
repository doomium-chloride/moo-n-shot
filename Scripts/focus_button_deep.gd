extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var monologue = owner
export var code = "next"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_on_button_press")


func _on_button_press():
	monologue.emit_signal(code)
