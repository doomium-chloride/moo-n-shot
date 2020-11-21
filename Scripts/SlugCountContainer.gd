extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var max_ammo = 11
export var interval = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	set_max_slug(max_ammo)
	set_interval(interval)
	Global.connect("update_ammo", self, "shoot")
	Global.connect("set_max_ammo", self, "set_max_slug")
	Global.connect("set_ammo_spacing", self, "set_interval")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func shoot(ammo):
	$SlugCount.shoot(ammo)

func set_max_slug(ammo):
	$SlugCount.max_slug = ammo
	
func set_interval(dist):
	$SlugCount.interval = dist
	$SlugCount.init_slug_position()
