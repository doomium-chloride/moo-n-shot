extends "res://Scripts/Monologue.gd"

const narr_length = 9
const narr_base = "res://sound/outro/narration-"
const narr_file_end = ".ogg"

var narration_audio = [null]

var slide_textures = [null]

const texture_names = [
	"res://pictures/outro/1 (ring).png",
	
	"res://pictures/outro/2 (yellow president speaking.png",
	"res://pictures/outro/2 (yellow president speaking.png",
	"res://pictures/outro/2 (yellow president speaking.png",
	"res://pictures/outro/2 (yellow president speaking.png",
	"res://pictures/outro/2 (yellow president speaking.png",
	"res://pictures/outro/2 (yellow president speaking.png",
	
	"res://pictures/outro/3 (who would have thought).png",
	"res://pictures/outro/4 (then you\'ve never been).png"
]

const slide_scales = [
	1,
	0.42,
	0.75,0.75,0.75,0.75,0.75,0.75,
	0.3,
	0.75
]

func _ready():
	#textbox = get_node("SlidePic/Text")
	next_scene = Global.main_menu
	text_array = [
		"...",
		"[Phone rings]",
		"Yellow! President Speaking.",
		"They've been wiped out I'm afraid. " \
			+ "The ship and the crew were annihilated.",
		"What!? All of them?",
		"Unfortunately so sir.",
		"The official story will be 'that we're holding a ceasefire'. " \
			+ "Don't let the media find out about this.",
		"Of course sir. [Hangs up phone]",
		"Who would have thought it would come to this. " \
			+ "Still, I should have know better than to have underestimate you. " \
			+ "But if you think this is over...",
		"...then you've never been more wrong."
	]
	init_narration_audio()
	init_slide_textures()
	init()

func get_narration_file(num):
	return narr_base + str(num) + narr_file_end

func init_narration_audio():
	for i in range(1,narr_length + 1):
		var audio = AudioStreamPlayer.new()
		audio.stream = load(get_narration_file(i))
		audio.stream.loop = false
		$Narration.add_child(audio)
		narration_audio.append(audio)

func init_slide_textures():
	for filename in texture_names:
		var texture = load(filename)
		slide_textures.append(texture)

func stop_all_audio():
	for audio in narration_audio:
		if audio != null:
			audio.stop()

func change_slide():
	stop_all_audio()
	var audio = narration_audio[current]
	if audio != null:
		audio.play()
	var slide = get_node("SlideContainer/Slide")
	$SlideContainer.rect_scale = Global.scale2(slide_scales[current])
	slide.texture = slide_textures[current]

func next_text():
	current += 1
	if current >= text_array.size():
		skip_monologue()
	else:
		type_text(text_array[current])
		change_slide()

func prev_text():
	if current > 0:
		current -= 1
		type_text(text_array[current])
		change_slide()
