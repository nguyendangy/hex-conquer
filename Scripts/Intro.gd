extends Node2D

@onready var animation_intro = $AnimationPlayer


func _ready():
	animation_intro.play("black_in")
	get_tree().create_timer(1).timeout.connect(black_out)
 

func black_out():
	animation_intro.play("black_out")
	get_tree().create_timer(1).timeout.connect(start_story_scene)
 

func start_story_scene():
	get_tree().change_scene_to_file("res://Scenes/Story.tscn")
