extends "res://Scripts/Monologue.gd"


func _ready():
	next_scene = "res://Scenes/Game.tscn"
	text_array = [
		"The year is 1969",
		"America has sent its finest astronauts on a lunar expedition",
		"The purpose: to establish the planet's first off-world dairy farm",
		"But when they finally arrived, they were shocked to see that any animals introduced to the moonscale mysteriously died",
		"Worse still, they discovered the cheese the moon was made from was completely inedible",
		"The moon was deemed inhospitable due to its seemingly unsurvivable environment and poor Wi-Fi reception",
		"The project was abandoned",
		"The lunar landing was considered a failiure and has since been dubbed 'The largest waste of US tax payer money' since the start of that week",
		"The ruins of the dairy farm still laid derelict, abandoned on the dark side of the moon",
		"The year is now 2020 2",
		"The only thing worse than 2020",
		"was when 2020 happened again",
		"The coronavirus has devastated the population",
		"The survival rate plummeting to 99.4%",
		"But humanity has found a glimmer of hope, in the stars",
		"The mysterious liquid found on the moon, once thought to be water, has turned out to be the miracle cure for the ravenous corona plague",
		"However, scientific inquiry has led us to learn that the liquid is in fact a kind of milk and has been such dubbed 'lunarous-lactoseen'",
		"For a time this mysterious remedy remained unknown",
		"Until one of the astronauts discovered something unexpected",
		"The farm animals, once thought to have perished on the moonscape had not only survived, but adapted to their harsh environment " \
			+ "and carved out a small paradise from the ruins of the abandoned dairy farm",
		"This adaption caused a mutation in the milk of the cows, providing it miraculous effects",
		"But the cows there had not forgotten humanity's betrayal, and they refuse to yield their healing gift",
		"Deciding they had no other choice",
		"America declared war on the moon",
		"Suiting up them up in advanced lunar resistant attire they sent their finest agriculturalists to the moon",
		"Their purpose: harvest the milk and cure humanity of its deadly plague",
		"But the cows will not go down without a fight",
		"And the dairy farm is not the only thing America has left behind..."
	]
	init()
