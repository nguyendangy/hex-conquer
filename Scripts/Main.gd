extends Node2D

var currentPlayer: Player.PlayerObject = Config.player
var turnNumber: int = 1

var game_over: bool = false

# Components
@onready var hud: Node = get_node("HUD")
@onready var map: Node = get_node("SubViewportContainer/SubViewport/Map")
@onready var outcome: Node = get_node("Outcome")
@onready var outcomeLabel: Node = get_node("Outcome/Label")

# Game mode
@onready var gameMode: String = get_node("/root/TitleScreen/ModeButton").text

# Multiplayer
@onready var multiplayerSelected: bool = get_node("/root/TitleScreen/CheckButton").button_pressed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.init_hud()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Called when the game is over
func end_game() -> void:
	# different game modes
	if gameMode == Config.gameModes[0]:
		if len(map.get_owned_tiles(Config.player)) <= len(map.get_owned_tiles(Config.opponent)):
			if multiplayerSelected:
				outcomeLabel.text = "Player 2 won!"
			else:
				outcomeLabel.text = "You lost!"
		else:
			if multiplayerSelected:
				outcomeLabel.text = "Player 1 won!"
			else:
				outcomeLabel.text = "You won!"
	elif gameMode == Config.gameModes[1]:
		if multiplayerSelected:
			outcomeLabel.text = "Player " + str(currentPlayer.terrain_id) + " won!"
		else:
			if currentPlayer == Config.player:
				outcomeLabel.text = "You won!"
			else:
				outcomeLabel.text = "You lost!"
	
	# show outcome
	outcome.visible = true
	
	# reset players
	Config.player.reset_player()
	Config.opponent.reset_player()
	
	# make a restart possible
	game_over = true
	hud.endTurnButton.text = "Return To Home"


# Called when the player ends the turn
func end_turn() -> void:
	
	if game_over:
		get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
	
	# different game modes
	if gameMode == Config.gameModes[0]:
		# check if game has ended
		if turnNumber >= Config.maxNumberOfTurns:
			end_game()
			return
	elif gameMode == Config.gameModes[1]:
		if currentPlayer.gold >= Config.maxNumberOfResource:
			end_game()
			return
	
	# update the resources of the player
	calculate_resources()
	currentPlayer.update_resources()
	
	# change current player
	if currentPlayer == Config.player:
		currentPlayer = Config.opponent
	elif currentPlayer == Config.opponent:
		currentPlayer = Config.player
		turnNumber += 1
	
	if currentPlayer == Config.opponent:
		if not multiplayerSelected:
			# execute the bot
			for i in range(0, Config.maxTilesPerTurn):
				map.conquer_random_tile(Config.opponent)
			end_turn()
	
	# update map
	map.end_turn()
	# update the HUD
	hud.update_hud()

func calculate_resources() -> void:
	# calculate the amount of resources the player gets next turn
	currentPlayer.lumberPerTurn = map.get_number_of_owned_tiles_by_terrain(1)
	currentPlayer.stonePerTurn = map.get_number_of_owned_tiles_by_terrain(Config.mine.terrain_id)
	currentPlayer.grainPerTurn = map.get_number_of_owned_tiles_by_terrain(Config.farm.terrain_id)
	currentPlayer.goldPerTurn = map.get_number_of_owned_tiles_by_terrain(Config.village.terrain_id)
	
