extends Panel

var lines = []  # Array to store the lines of text
var current_line_index = 0  # Tracks the current line index

func _ready() -> void:
	# Initialize the text as an array of lines
	lines = """
	The battle for survival has come to an end. 
	The factions have fought valiantly, each striving for control over the scarce remnants of a broken world.
	Amid the chaos, alliances were forged, betrayals unfolded, and victories were hard-won.
	Now, the land bears the scars of conflict, but also a glimmer of hope. The choices made today will shape the future of tomorrow.
	You have risen as a conqueror, but your journey is far from over. Will you rebuild this fractured world, or will history repeat itself?
	The decision rests in your hands. Until we meet again, farewell.
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
		$BackMainButton.visible = true  # If there's a "Start Game" button
