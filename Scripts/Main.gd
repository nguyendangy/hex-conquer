extends Node2D

var currentPlayer: Player.PlayerObject = Config.player
var turnNumber: int = 1

var game_over: bool = false

# Components
@onready var hud: Node = get_node("HUD")
@onready var map: Node = get_node("SubViewportContainer/SubViewport/Map")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if Config.import:
		import_data()
	
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

# Calculate the amount of resources the player gets next turn
func calculate_resources() -> void:
	currentPlayer.lumberPerTurn = map.get_number_of_owned_tiles_by_terrain(1)
	currentPlayer.stonePerTurn = map.get_number_of_owned_tiles_by_terrain(Config.mine.terrain_id)
	currentPlayer.grainPerTurn = map.get_number_of_owned_tiles_by_terrain(Config.farm.terrain_id)
	currentPlayer.goldPerTurn = map.get_number_of_owned_tiles_by_terrain(Config.village.terrain_id)

# Export the data of the game
func export_data() -> void:
	var map_list = []
	for t in map.allTiles:
		map_list.append({
			"x": t.x,
			"y": t.y,
			"terrain": map.get_cell_tile_data(t).terrain, 
			"terrain_set": map.get_cell_tile_data(t).terrain_set
		})
	
	var player_dict = {}
	player_dict["player"] = Config.player.get_data_dict()
	player_dict["opponent"] = Config.opponent.get_data_dict()
	
	var structure_dict = {}
	structure_dict["castle"] = Config.castle.get_data_dict()
	structure_dict["camp"] = Config.camp.get_data_dict()
	structure_dict["tower"] = Config.tower.get_data_dict()
	structure_dict["village"] = Config.village.get_data_dict()
	structure_dict["farm"] = Config.farm.get_data_dict()
	structure_dict["mine"] = Config.mine.get_data_dict()
	
	var meta_dict = {}
	meta_dict["turnNumber"] = turnNumber
	meta_dict["currentPlayer"] = currentPlayer.terrain_id
	meta_dict["gameMode"] = Config.gameMode
	meta_dict["multiplayerSelected"] = Config.multiplayerSelected
	
	$TextEdit.text = "{"
	$TextEdit.text += "\"map\":" + str(JSON.stringify(map_list)) + ","
	$TextEdit.text += "\"player\":" + str(JSON.stringify(player_dict)) + ","
	$TextEdit.text += "\"structures\":" + str(JSON.stringify(structure_dict)) + ","
	$TextEdit.text += "\"meta\":" + str(JSON.stringify(meta_dict))
	$TextEdit.text += "}"
	
	$TextEdit.visible = not $TextEdit.visible
	if hud.exportButton.text == "Hide export":
		hud.exportButton.text = "Export"
	else:
		hud.exportButton.text = "Hide export"


func import_data() -> void:
	var json = JSON.new()
	var import_status = json.parse(Config.importData)
	if import_status == OK:
		var data_received = json.data
		# map data
		for tile in data_received.map:
			map.set_cells_terrain_connect([Vector2i(tile.x, tile.y)], tile.terrain_set, tile.terrain)
		# player data
		Config.player.set_data_dict(data_received.player.player)
		Config.opponent.set_data_dict(data_received.player.opponent)
		# structure data
		Config.castle.set_data_dict(data_received.structures.castle)
		Config.camp.set_data_dict(data_received.structures.camp)
		Config.tower.set_data_dict(data_received.structures.tower)
		Config.village.set_data_dict(data_received.structures.village)
		Config.farm.set_data_dict(data_received.structures.farm)
		Config.mine.set_data_dict(data_received.structures.mine)
		# meta data
		turnNumber = data_received.meta.turnNumber
		if data_received.meta.currentPlayer == 1:
			currentPlayer = Config.player
		else:
			currentPlayer = Config.opponent
		Config.gameMode = data_received.meta.gameMode
		Config.multiplayerSelected = data_received.meta.multiplayerSelected
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
