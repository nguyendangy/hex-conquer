extends TileMapLayer

# Tiles
var allTiles: Array
var selectedTile: Vector2i = Vector2i(-1, -1)
var tilesPerTurn: int = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var main: Node = get_node("/root/Main")
@onready var hud: Node = get_node("/root/Main/HUD")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set seed for random number generator
	#rng.set_seed(1)

	# get all tiles on the map
	allTiles = get_used_cells()
	# set terrain for each tile randomly according weighted distribution
	for tile in allTiles:
		set_cells_terrain_connect([tile], 0, _get_terrain_type())
	
	# set castles
	set_cells_terrain_connect([Config.player.startingTile], Config.player.terrain_id, Config.castle.terrain_id)
	set_cells_terrain_connect([Config.opponent.startingTile], Config.opponent.terrain_id, Config.castle.terrain_id)

	# check that not all tiles around castle are uncapturable
	var castle_surroundings: Array = get_surrounding_cells(Config.player.startingTile)
	var capturable: int = len(castle_surroundings.filter(func(x): return x in Config.capturable_tiles))
	while(capturable < 3):
		for tile in castle_surroundings:
			set_cells_terrain_connect([tile], 0, _get_terrain_type())
		capturable = len(get_surrounding_cells(Config.player.startingTile).filter(
			func(x): return get_cell_tile_data(x).terrain in Config.capturable_tiles))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#var mouse_pos = get_viewport().get_mouse_position()
	#var coordinates = get_global_transform_with_canvas().affine_inverse() * mouse_pos
	#var pos_clicked = local_to_map(coordinates)
	#
	#if pos_clicked in allTiles:
		#print(pos_clicked)
	
	pass

# Handle input events
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			# locate event and transform to map coordiantes
			var coordinates = get_global_transform_with_canvas().affine_inverse() * event.position
			var pos_clicked = local_to_map(coordinates)
			
			# check if clicked tile is on the map
			if pos_clicked in allTiles:
				selectedTile = pos_clicked
				
				# own tile clicked, show possible options
				if pos_clicked in get_owned_tiles(main.currentPlayer):
					clear_all_tiles()
					hud.set_buttons_visibility(get_placable_structures(pos_clicked))
					if tilesPerTurn < Config.maxTilesPerTurn:
						mark_possible_tiles(pos_clicked)
					set_cell(pos_clicked, get_cell_source_id(pos_clicked), \
						get_cell_atlas_coords(pos_clicked), 2)
				else:
					# surrounding tile clicked
					if get_cell_alternative_tile(pos_clicked) == 1:
						clear_all_tiles()
						
						var pos_clicked_data = get_cell_tile_data(pos_clicked)
						if pos_clicked_data.terrain == Config.camp.terrain_id:
							# destroy camp
							set_cells_terrain_connect([pos_clicked], 0, 	0)
						elif pos_clicked_data.terrain_set != main.currentPlayer.terrain_id \
							and pos_clicked_data.terrain_set != 0:
								# to conquer an opponnent possessed tile, a camp needs to be next to it
								if Config.camp.terrain_id in get_surrounding_cells(pos_clicked).map(
									func(x): return get_cell_tile_data(x).terrain):
										set_cells_terrain_connect([pos_clicked], main.currentPlayer.terrain_id, \
											get_cell_tile_data(pos_clicked).terrain)
						else:
							set_cells_terrain_connect([pos_clicked], main.currentPlayer.terrain_id, \
								pos_clicked_data.terrain)
						
						tilesPerTurn += 1
						# remove tiles that are not connected anymore
						remove_disconnected_tiles()
						# update players resource benefit
						main.calculate_resources()
					
					clear_all_tiles()
					hud.update_hud()
					selectedTile = Vector2i(-1,-1)

# Get terrain_id of random selected tile
func _get_terrain_type() -> int:
	var remaining_distance = rng.randf()
	for i in Config.tiles.size():
		remaining_distance -= Config.tiles[i][1]
		if remaining_distance < 0:
			return Config.tiles[i][0]
	return 0

# Mark tiles that can be conquered
func mark_possible_tiles(pos_clicked: Vector2i) -> void:
	var ownedTiles = get_owned_tiles(main.currentPlayer)
	# Surrounding tiles
	if pos_clicked in allTiles and pos_clicked in ownedTiles:
		for cell in get_surrounding_cells(pos_clicked):
			if cell in allTiles and cell not in ownedTiles \
				and get_cell_tile_data(cell).terrain in Config.capturable_tiles:
				set_cell(cell, get_cell_source_id(cell), \
					get_cell_atlas_coords(cell), (get_cell_alternative_tile(cell) + 1) %  2)

# Reset all marked tiles
func clear_all_tiles() -> void:
	for cell in allTiles:
		set_cell(cell, get_cell_source_id(cell), get_cell_atlas_coords(cell), 0)

# Get owned tiles of player
func get_owned_tiles(player: Player.PlayerObject) -> Array:
	return get_used_cells().filter(func(x): return get_cell_tile_data(x).terrain_set == player.terrain_id)

# Get amount of owned tiles of this type
func get_number_of_owned_tiles_by_terrain(terrain: int) -> int:
	return len(get_owned_tiles(main.currentPlayer).filter(func(x): return get_cell_tile_data(x).terrain == terrain))

# Check if structure can be placed on tile
func get_placable_structures(tile: Vector2i) -> Array:
	var placeable: Array = []
	for structure in Config.placable_structures:
		if tile in get_owned_tiles(main.currentPlayer) and \
			get_cell_tile_data(tile).terrain in structure.placedOnTiles and \
			main.currentPlayer.lumber >= structure.lumber and \
			main.currentPlayer.stone >= structure.stone and \
			main.currentPlayer.grain >= structure.grain and \
			main.currentPlayer.gold >= structure.gold and \
			(structure.adjacentTileType == -1 or structure.adjacentTileType in \
			get_surrounding_cells(tile).filter(func(x): return x in allTiles).map(
				func(x): return get_cell_tile_data(x).terrain)):
			placeable.append(structure)
	return placeable

# Place strucutre on currently selected tile
func place_structure(structure: Structure.StructureObject) -> void:
	clear_all_tiles()
	set_cells_terrain_connect([selectedTile], main.currentPlayer.terrain_id, structure.terrain_id)
	main.currentPlayer.lumber -= structure.lumber
	main.currentPlayer.stone -= structure.stone
	main.currentPlayer.grain -= structure.grain
	main.currentPlayer.gold -= structure.gold
	main.calculate_resources()
	
	# increase the price of the structure
	#structure.lumber *= 2
	#structure.stone *= 2
	#structure.grain *= 2
	#structure.gold *= 2
	structure.lumber += structure.lumberPerTurn
	structure.stone += structure.stonePerTurn
	structure.grain += structure.grainPerTurn
	structure.gold += structure.goldPerTurn
	
	# update hud
	hud.update_hud()

# Things to do on the end of a turn
func end_turn() -> void:
	clear_all_tiles()
	# remove tiles that are not connected anymore
	remove_disconnected_tiles()
	tilesPerTurn = 0

# Conquer tile for opponent
func conquer_random_tile(player: Player.PlayerObject) -> void:
	var possibleTiles : Array = []
	var ownedTiles = get_owned_tiles(player)

	for tile in ownedTiles:
		var surroundingTiles = get_surrounding_cells(tile)
		for t in surroundingTiles:
			if t in allTiles and t not in ownedTiles and get_cell_tile_data(t).terrain in Config.capturable_tiles:
				possibleTiles.append(t)
	
	if len(possibleTiles) > 0:
		var choosen = possibleTiles.pick_random()

		if get_cell_tile_data(choosen).terrain == Config.camp.terrain_id:
			set_cells_terrain_connect([choosen], 0, 	0)
		else:
			set_cells_terrain_connect([choosen], player.terrain_id, get_cell_tile_data(choosen).terrain)

# Recursively check if the tile is connected to the castle
func is_connected_to_castle(connected: Array, tile: Vector2i, owned: Array) -> Array:
	var neighbors = get_surrounding_cells(tile).filter(func(x): return x in owned)
	for n in neighbors:
		if n not in connected:
			connected.append(n)
			connected = is_connected_to_castle(connected, n, owned)
	return connected

# Remove tiles that are no longer connected to the main castle
func remove_disconnected_tiles() -> void:
	var lost : Array = []
	
	# player
	var ownedTiles : Array = get_owned_tiles(Config.player)
	var connected : Array = is_connected_to_castle([Config.player.startingTile], Config.player.startingTile, ownedTiles)
	
	for tile in ownedTiles:
		if tile not in connected:
			lost.append(tile)
	
	# opponent
	ownedTiles = get_owned_tiles(Config.opponent)
	connected = is_connected_to_castle([Config.opponent.startingTile], Config.opponent.startingTile, ownedTiles)

	for tile in ownedTiles:
		if tile not in connected:
			lost.append(tile)
	
	# reset all disconnected tiles
	for tile in lost:
		set_cells_terrain_connect([tile], 0, get_cell_tile_data(tile).terrain)
