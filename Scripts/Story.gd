extends Panel

# story text
const startText: Array = [
	"In a post-apocalyptic world, two factions battle for control.",
	"The land is vast and resources are limited. Who rules the empire?",
	"Lead your faction to victory with strategy, courage, and clever tactics!",
	"Your journey won't be easy, as your opponent will try to stop you at every turn.",
	"Will you rise as a conqueror or fade into obscurity? The choice is yours."
]
const endText: Array = [
	"",
	"The land has been claimed, but the scars of war are still visible.",
	"The future remains uncertain. Will the cycle of conflict start again?",
	"You have the choice. Farewell, for now, conqueror.",
]

var current_line_index: int = 0

@onready var animation_intro = $AnimationPlayer


func _ready() -> void:
	
	# display the first line of the text
	if Config.gameOver:
		$Background/StartImage.visible = false
		$Background/EndImage.visible = true
		if Config.multiplayerSelected:
			$Text/Label.text = "[center]" + "Player " + str(Config.winner.terrain_id) + " won the battle!"
		else:
			if Config.winner == Config.player:
				$Text/Label.text = "[center]" + "Your faction has emerged victorious from the battle!"
			else:
				$Text/Label.text = "[center]" + "Your faction was defeated in the battle!"
	else:
		$Background/StartImage.visible = true
		$Background/EndImage.visible = false
		$Text/Label.text = "[center]" + startText[current_line_index]
		
	animation_intro.play("black_in")
	


func _on_NextButton_pressed() -> void:
	animation_intro.play("black_out")
	await get_tree().create_timer(0.25).timeout
	
	var lines: Array = []
	if Config.gameOver:
		lines = endText
	else:
		lines = startText
	
	if current_line_index < lines.size() - 1:
		current_line_index += 1
		$Text/Label.text = "[center]" + lines[current_line_index]
		
		animation_intro.play("black_in")
	else:
		current_line_index = 0
		get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")


func _on_SkipButton_pressed() -> void:
	current_line_index = 0
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
