extends Control

signal next
signal skip
signal prev

onready var global = get_node("/root/global")
onready var textbox = get_node("Text")
onready var next_button = get_node("Next")
onready var skip_button = get_node("Skip")
onready var prev_button = get_node("Prev")
onready var typer = get_node("Typer")

var text_array = ["..."]
var current = 0

var typed_text = ""
var to_type = ""
var letter_count = 0
var text_length = 0

var selected_button = -1

export var next_scene = "res://Scenes/Menus/Home.tscn"

onready var buttons = [prev_button, skip_button, next_button]

func _ready():
	connect("next",self,"next_text")
	connect("skip",self,"skip_monologue")
	connect("prev",self,"prev_text")
	
	typer.connect("timeout", self, "type_letter")
	init()
	set_process(true)

func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		focus_left()
	if Input.is_action_just_pressed("ui_right"):
		focus_right()

func focus_left():
	if selected_button > 0:
		if len(buttons) > 0:
			selected_button -= 1
			update_selected_button()
	elif selected_button <= 0:
		selected_button = len(buttons) - 1
		update_selected_button()
			
func focus_right():
	if selected_button < (len(buttons) - 1):
		selected_button += 1
		update_selected_button()
	elif selected_button == len(buttons) - 1:
		selected_button = 0
		update_selected_button()

func update_selected_button():
	buttons[selected_button].grab_focus()
	
func add_text(text):
	text_array.append(text)
	
func next_text():
	current += 1
	if current >= text_array.size():
		skip_monologue()
	else:
		type_text(text_array[current])

func prev_text():
	if current > 0:
		current -= 1
		type_text(text_array[current])
		
func skip_monologue():
	Global.goto_scene(next_scene)

func init():
	type_text(text_array[current])

func clear_text():
	textbox.text = ""

func type_text(text):
	to_type = text
	typed_text = ""
	text_length = len(to_type)
	letter_count = 0
	typer.start()

func type_letter():
	if letter_count >= text_length:
		typer.stop()
		letter_count = 0
		text_length = 0
		to_type = ""
		return
	else:
		typed_text += to_type[letter_count]
		textbox.text = typed_text
		letter_count += 1
