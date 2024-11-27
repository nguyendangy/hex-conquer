extends Panel

# story text
const startText: Array = [
	"In a post-apocalyptic world, factions vie for control over scarce resources.",
	"Lead your faction to victory through strategy, courage, and wit!",
	"The land is vast, yet resources are scarce. You must build, conquer, and outwit your opponent to dominate the land.",
	"Your journey will not be easy, as the rival faction seek to thwart your progress at every turn.",
	"Will you rise as a conqueror or fade into obscurity? The choice is yours."
]
const endText: Array = [
	"",
	"The battle for survival has come to an end.",
	"The factions have fought valiantly, each striving for control over the scarce remnants of a broken world.",
	"Amid the chaos, alliances were forged, betrayals unfolded, and victories were hard-won.",
	"Now, the land bears the scars of conflict, but also a glimmer of hope. The choices made today will shape the future of tomorrow.",
	"You have risen as a conqueror, but your journey is far from over.",
	"Will you rebuild this fractured world, or will history repeat itself?",
	"The decision rests in your hands. Until we meet again, farewell."
]

var current_line_index: int = 0


func _ready() -> void:
	
	# display the first line of the text
	if Config.gameOver:
		$Background/StartImage.visible = false
		$Background/EndImage.visible = true
		if Config.multiplayerSelected:
			$Text/Label.text = "[center]" + "Player " + str(Config.winner.terrain_id) + " won the battle!"
		else:
			if Config.winner == Config.player:
				$Text/Label.text = "[center]" + "You won the battle!"
			else:
				$Text/Label.text = "[center]" + "You lost the battle!"
	else:
		$Background/StartImage.visible = true
		$Background/EndImage.visible = false
		$Text/Label.text = "[center]" + startText[current_line_index] 


func _on_NextButton_pressed() -> void:
	var lines: Array = []
	if Config.gameOver:
		lines = endText
	else:
		lines = startText
	
	if current_line_index < lines.size() - 1:
		current_line_index += 1
		$Text/Label.text = "[center]" + lines[current_line_index]
	else:
		current_line_index = 0
		get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")


func _on_SkipButton_pressed() -> void:
	current_line_index = 0
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
