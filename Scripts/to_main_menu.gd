extends Button

func _ready():
	connect("pressed", self, "_on_Button_pressed")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_Button_pressed()

func _on_Button_pressed():
	Global.goto_scene(Global.main_menu)

