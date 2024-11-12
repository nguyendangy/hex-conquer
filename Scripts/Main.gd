extends Node2D

# current amount of each resource we have
var lumber : int = 0
var stone : int = 0
var grain : int = 0
var gold : int = 0

# amount of each resource we get each turn
var lumberPerTurn : int = 1
var stonePerTurn : int = 1
var grainPerTurn : int = 1
var goldPerTurn : int = 1

var currentTurn : int = 1
var maxNumberOfTurns : int = 50
var maxTilesPerTurn : int = 5

var game_over = false

# components
@onready var hud : Node = get_node("HUD")
@onready var map : Node = get_node("SubViewportContainer/SubViewport/Map")
@onready var outcome : Node = get_node("/root/Main/Outcome")
@onready var outcomeLabel : Node = get_node("/root/Main/Outcome/Label")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# update the HUD when the game starts
	hud.update_hud()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# called when the game is over
func end_game() -> void:
	# show outcome
	if len(map.ownedTiles) <= len(map.opponentOwnedTiles):
		outcomeLabel.text = "You lost!"
	else:
		outcomeLabel.text = "You won!"
	outcome.visible = true
	
	# make a restart possible
	game_over = true
	hud.endTurnButton.text = "Return To Home"


# called when the player ends the turn
func end_turn() -> void:
	
	if currentTurn >= maxNumberOfTurns:
		if game_over:
			get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
		end_game()
		return
	
	# update our current resource amounts
	lumber += lumberPerTurn
	stone += stonePerTurn
	grain += grainPerTurn
	gold += goldPerTurn
	
	# update how many resources the player gets
	lumberPerTurn = map.get_number_of_owned_tiles_by_terrain(1) + 1
	stonePerTurn = map.get_number_of_owned_tiles_by_terrain(2) + 1
	
	# increase current turn
	currentTurn += 1
	
	# update the HUD
	hud.update_hud()
	
	# update map
	map.end_turn()
	
	# Opponents turn
	opponent()
	

func opponent() -> void:
	# Simple opponent
	
	for i in range(0, maxTilesPerTurn):
		map.conquer_random_tile()
	
	
