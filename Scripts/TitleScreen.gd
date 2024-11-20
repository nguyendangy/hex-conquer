extends Button


func _on_StartButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/StartStory.tscn")


func _on_HelpButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/HelpPage.tscn")


func _on_BackButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")

func _on_StartGame_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _on_back_main_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")

func _on_pressed() -> void:
	pass # Replace with function body.
