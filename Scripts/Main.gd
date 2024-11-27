extends Node2D

var currentPlayer: Player.PlayerObject = Config.player
var turnNumber: int = 1

var game_over: bool = false

# Components
@onready var hud: Node = get_node("HUD")
@onready var map: Node = get_node("SubViewportContainer/SubViewport/Map")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.init_hud()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Called when the game is over
func end_game() -> void:
	# different game modes
	if Config.gameMode == 0:
		if len(map.get_owned_tiles(Config.player)) <= len(map.get_owned_tiles(Config.opponent)):
			Config.winner = Config.opponent
		else:
			Config.winner = Config.player
	elif Config.gameMode == 1:
		Config.winner = currentPlayer
	
	# reset players
	Config.player.reset_player()
	Config.opponent.reset_player()
	
	# make a restart possible
	Config.gameOver = true
	
	# change to ending story
	get_tree().change_scene_to_file("res://Scenes/Story.tscn")


# Called when the player ends the turn
func end_turn() -> void:
	
	# different game modes
	if Config.gameMode == 0:
		# check if game has ended
		if turnNumber >= Config.maxNumberOfTurns:
			end_game()
			return
	elif Config.gameMode == 1:
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
		if not Config.multiplayerSelected:
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
