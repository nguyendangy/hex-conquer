extends Panel

var lines = []  # Array to store the lines of text
var current_line_index = 0  # Tracks the current line index

func _ready() -> void:
	# Initialize the text as an array of lines
	lines = """
	In a post-apocalyptic world, factions vie for control over scarce resources.
	Lead your faction to victory through strategy, courage, and wit!
	The land is vast, yet resources are scarce. You must build, conquer, and outwit your opponents to dominate the land.
	Your journey will not be easy, as rival factions seek to thwart your progress at every turn.
	Will you rise as a conqueror or fade into obscurity? The choice is yours.
	""".strip_edges().split("\n")

	# Start the audio when the scene is ready
	if $AudioStreamPlayer:
		$AudioStreamPlayer.play()  # Start playing audio at the beginning of the scene

	# Display the first line
	_display_current_line()

	# Connect the "Next" button signal using a Callable
	$NextStoryButton.pressed.connect(_on_next_story_button_pressed)

func _display_current_line():
	# Display the current line in the RichTextLabel
	$RichTextLabel.text = lines[current_line_index]
	
	# Ensure audio does not restart if already playing
	if $AudioStreamPlayer:
		if not $AudioStreamPlayer.playing:  # Check if the audio is already playing
			$AudioStreamPlayer.play()
	else:
		print("Error: AudioStreamPlayer not found in the scene!")

func _on_next_story_button_pressed() -> void:
	# Move to the next line
	if current_line_index < lines.size() - 1:
		current_line_index += 1
		_display_current_line()
	else:
		# Optionally, hide the button or proceed to the next scene
		$NextStoryButton.disabled = true
		$StartGameButton.visible = true  # If there's a "Start Game" button
