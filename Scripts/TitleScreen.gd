extends Control


func _on_VersionLabel_ready() -> void:
	get_node("/root/TitleScreen/VersionLabel").text = "version " + str(Config.version)

func _on_StartButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_ModeButton_pressed() -> void:
	var text: String = get_node("/root/TitleScreen/ModeButton").text
	if text == Config.gameModes[0]:
		get_node("/root/TitleScreen/ModeButton").text = Config.gameModes[1]
		get_node("/root/TitleScreen/ModeButton").set_text(Config.gameModes[1])
		Config.gameMode = 0
	else:
		get_node("/root/TitleScreen/ModeButton").text = Config.gameModes[0]
		get_node("/root/TitleScreen/ModeButton").set_text(Config.gameModes[0])
		Config.gameMode = 1


func _on_HelpButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/HelpPage.tscn")


func _on_BackButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")


func _on_CheckButton_toggled(toggled_on: bool) -> void:
	get_node("/root/TitleScreen/CheckButton").button_pressed = toggled_on
	Config.multiplayerSelected = toggled_on


func _on_ImportButton_pressed() -> void:
	get_node("/root/TitleScreen/Import").visible = not get_node("/root/TitleScreen/Import").visible
	Config.import = true
	Config.importData = get_node("/root/TitleScreen/Import/TextEdit").text
	
	var importButton = get_node("/root/TitleScreen/CenterContainer/ImportButton")
	if importButton.text == "Import Game":
		importButton.text = "Import"
	else:
		importButton.text = "Import Game"
