extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_StartButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_HelpButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/HelpPage.tscn")


func _on_BackButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
