extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var blinking = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Prompt.visible = false
	Global.connect("update_ammo", self, "_on_ammo_update")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_ammo_update(ammo):
	if ammo <= Global.low_ammo and not blinking:
		$Prompt.visible = true
		$Flashing.start()
		blinking = true
		
	elif ammo > Global.low_ammo and blinking:
		$Prompt.visible = false
		$Flashing.stop()
		blinking = false



func _on_Flashing_timeout():
	$Prompt.visible = !$Prompt.visible
