extends "res://Scripts/Monologue.gd"

const narr_length = 28
const narr_base = "res://sound/intro/narration-"
const narr_file_end = ".ogg"

var narration_audio = [null]

var slide_textures = [null]

const texture_names = [
	"res://pictures/intro/part 1/1 (the year) rocket.jpg",
	"res://pictures/intro/part 1/1 (the year) rocket.jpg",
	"res://pictures/intro/part 1/2 (the purpose) moon.jpg",
	"res://pictures/intro/part 1/3 (but when they) space cows.jpg",
	"res://pictures/intro/part 1/4 1 (worse still) cheese .png",
	"res://pictures/intro/part 1/4 2(was completely) cheese.jpg",
	"res://pictures/intro/part 1/5 (the moon was deemed).png",
	"res://pictures/intro/part 1/5 2 (and poor wifi) wifi.jpg",
	"res://pictures/intro/part 1/6 (the lunar landing was) F paper.jpg",
	"res://pictures/intro/part 1/7 (the ruins of) old dairy farm.png",
	"res://pictures/intro/part 1/7 (the ruins of) old dairy farm.png",
	"res://pictures/intro/part 2/1 (the year is now 2020 2).png",
	"res://pictures/intro/part 2/1 (the year is now 2020 2).png",
	"res://pictures/intro/part 2/2 (the corona virus has).png",
	"res://pictures/intro/part 2/3 (but humanity has) moon.jpg",
	"res://pictures/intro/part 2/4 (the mysterious liquid).png",
	"res://pictures/intro/part 2/5 (however scientific inquiry) - Copy.jpg",
	"res://pictures/intro/part 2/6 (is infact a kind of milk).png",
	"res://pictures/intro/part 2/6 (is infact a kind of milk).png",
	"res://pictures/intro/part 2/7 (until one of the astronauts).png",
	"res://pictures/intro/part 2/7 (until one of the astronauts).png",
	"res://pictures/intro/part 2/8 (this adaption).jpg",
	"res://pictures/intro/part 2/9 (but the cows there).png",
	"res://pictures/intro/part 2/10 (deciding they had no other choice).png",
	"res://pictures/intro/part 2/11 (suiting them up in their).png",
	"res://pictures/intro/part 2/11 (suiting them up in their).png",
	"res://pictures/intro/part 2/12 (but the cows will not).png",
	"res://pictures/intro/part 2/12 (but the cows will not).png"
]

const slide_scales = [
	1,
	0.5,0.5,
	0.3,
	0.6,
	0.5,
	0.5,
	0.4,
	0.35,
	1,
	0.35,0.35,
	0.1,0.1,
	0.5,
	0.3,
	0.3,
	0.7,
	0.3,0.3,
	0.35,0.35,
	0.7,
	0.33,
	0.8,
	0.6,0.6,
	0.65,
	0.65
]

func _ready():
	#textbox = get_node("SlidePic/Text")
	next_scene = "res://Scenes/Game.tscn"
	text_array = [
		"...",
		"The year is 1969", 
		"America has sent its finest astronauts on a lunar expedition",
		"The purpose: to establish the planet's first off-world dairy farm",
		"But when they finally arrived, they were shocked to see that any animals introduced to the moonscape mysteriously died",
		"Worse still, they discovered the cheese the moon was made from...",
		"...was completely inedible",
		"The moon was deemed inhospitable due to its seemingly unsurvivable environment", 
		"and poor Wi-Fi reception",
		"The project was abandoned",
		"The lunar landing was considered a failiure and has since been dubbed " \
			+ "'The largest waste of US tax payer money' since the start of that week",
		"The ruins of the dairy farm still laid derelict, abandoned on the dark side of the moon",
		"The year is now 2020 2",
		"The only thing worse than 2020 was when 2020 happened again",
		"The coronavirus has devastated the population\n" + "The survival rate plummeting to 99.4%",
		"But humanity has found a glimmer of hope, in the stars",
		"The mysterious liquid found on the moon, once thought to be water, has turned out to be the miracle cure for the ravenous corona plague",
		"However, scientific inquiry has led us to learn that the liquid...",
		"...is in fact a kind of milk and has been such dubbed 'lunarous-lactoseen'\n",
		"For a time this mysterious remedy remained unknown",
		"Until one of the astronauts discovered something unexpected",
		"The farm animals, once thought to have perished on the moonscape had not only survived, " \
			+ "but adapted to their harsh environment and carved out a small paradise from the ruins of the abandoned dairy farm",
		"This adaption caused a mutation in the milk of the cows, providing it miraculous effects",
		"But the cows there had not forgotten humanity's betrayal, and they refuse to yield their healing gift",
		"Deciding they had no other choice\n" + "America declared war on the moon",
		"Suiting up them up in advanced lunar resistant attire they sent their finest agriculturalists to the moon\n",
		"Their purpose: harvest the milk and cure humanity of its deadly plague",
		"But the cows will not go down without a fight\n" + "And the dairy farm is not the only thing America has left behind...",
		"[Prepare for combat]"
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
