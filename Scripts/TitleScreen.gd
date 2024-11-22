extends Button


func _ready() -> void:
	get_node("/root/TitleScreen/VersionLabel").text = "version " + str(Config.version)


func _on_StartButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_ModeButton_pressed() -> void:
	var text: String = get_node("/root/TitleScreen/ModeButton").text
	if text == Config.gameModes[0]:
		get_node("/root/TitleScreen/ModeButton").text = Config.gameModes[1]
		set_text(Config.gameModes[1])
	else:
		get_node("/root/TitleScreen/ModeButton").text = Config.gameModes[0]
		set_text(Config.gameModes[0])


func _on_HelpButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/HelpPage.tscn")


func _on_BackButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")


func _on_toggled(toggled_on: bool) -> void:
	get_node("/root/TitleScreen/CheckButton").button_pressed = toggled_on
