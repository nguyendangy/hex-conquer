extends TileMapLayer

# Tiles
var allTiles : Array
var ownedTiles : Array
var startingTile : Vector2i = Vector2i(12, 21)
var selectedTile : Vector2i = Vector2i(-1, -1)
var opponentOwnedTiles : Array
var opponentStartingTile : Vector2i = Vector2i(12, 1)

var tilesPerTurn : int = 0

var rng = RandomNumberGenerator.new()

@onready var main : Node = get_node("/root/Main")
@onready var HUD : Node = get_node("/root/Main/HUD")


# Probabilities for different terrains
const gras : float = 0.5
const forest : float = 0.3
const mountains : float = 0.1
const river : float = 0.1
const weights : Array = [gras, forest, mountains, river]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set seed for random number generator
	#rng.set_seed(1)

	# get all tiles on the map
	allTiles = get_used_cells()
	# set terrain for each tile randomly according weighted distribution
	for tile in allTiles:
		set_cells_terrain_connect([tile], 0, _get_terrain_type())

	# set castle
	ownedTiles.append(startingTile)
	set_cells_terrain_connect([startingTile], 1, 4)
	
	# set castle for opponent
	opponentOwnedTiles.append(opponentStartingTile)
	set_cells_terrain_connect([opponentStartingTile], 2, 4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Handle input events
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			# locate event and transform to map coordiantes
			var coordinates = get_global_transform_with_canvas().affine_inverse() * event.position
			var pos_clicked = local_to_map(coordinates)
			
			if pos_clicked in allTiles:
				print(pos_clicked)
				
				selectedTile = pos_clicked
				
				# own tile clicked, show possible options
				if pos_clicked in ownedTiles:
					clear_all_tiles()
					if can_place_structure(5, selectedTile):
						HUD.set_buttons_visibility(true)
					else:
						HUD.set_buttons_visibility(false)
					if tilesPerTurn < main.maxTilesPerTurn:
						mark_possible_tiles(pos_clicked)
				else:
					# surrounding tile clicked
					if get_cell_alternative_tile(pos_clicked) == 1:
						clear_all_tiles()
						opponentOwnedTiles.erase(pos_clicked)
						ownedTiles.append(pos_clicked)
						tilesPerTurn += 1
						set_cells_terrain_connect([pos_clicked], 1, \
							get_cell_tile_data(pos_clicked).terrain)
						
						# remove opponents tiles that are not connected anymore
						remove_disconnected_tiles(opponentStartingTile, opponentOwnedTiles)
					
					clear_all_tiles()
					HUD.set_buttons_visibility(false)
					selectedTile = Vector2i(-1,-1)

# Get weighted random number 
func _get_terrain_type() -> int:
	var remaining_distance = rng.randf()
	for i in weights.size():
		remaining_distance -= weights[i]
		if remaining_distance < 0:
			return i
	return 0

# Mark tiles that can be conquered
func mark_possible_tiles(pos_clicked: Vector2i) -> void:
	# Surrounding tiles
	if pos_clicked in allTiles and pos_clicked in ownedTiles:
		for cell in get_surrounding_cells(pos_clicked):
			if cell in allTiles and cell not in ownedTiles and get_cell_tile_data(cell).terrain in [0,1,2,3]:
				set_cell(cell, get_cell_source_id(cell), \
					get_cell_atlas_coords(cell), (get_cell_alternative_tile(cell) + 1) %  2)

# Reset all marked tiles
func clear_all_tiles() -> void:
	for cell in allTiles:
		set_cell(cell, get_cell_source_id(cell), get_cell_atlas_coords(cell), 0)


# Get amount of owned tiles of this type
func get_number_of_owned_tiles_by_terrain(terrain: int) -> int:
	return len(ownedTiles.filter(func(x): return get_cell_tile_data(x).terrain == terrain))

# Check if structure can be placed on tile
func can_place_structure(structure: int, tile: Vector2i) -> bool:
	if tile in ownedTiles:
		match structure:
			# camp
			5: return get_cell_tile_data(tile).terrain in [0,1] and main.lumber >= 5
		return false
	else:
		return false

# Place camp on currently selected tile if possible
func place_camp() -> void:
	if can_place_structure(5, selectedTile):
		clear_all_tiles()
		set_cells_terrain_connect([selectedTile], 1, 5)
		main.lumber -= 5

# Things to do on the end of a turn
func end_turn() -> void:
	clear_all_tiles()
	# remove players tiles that are not connected anymore
	remove_disconnected_tiles(startingTile, ownedTiles)
	tilesPerTurn = 0

# Conquer tile for opponent
func conquer_random_tile() -> void:
	var possibleTiles : Array = []
	for tile in opponentOwnedTiles:
		var surroundingTiles = get_surrounding_cells(tile)
		for t in surroundingTiles:
			if t in allTiles and t not in opponentOwnedTiles and get_cell_tile_data(t).terrain < 4:
				possibleTiles.append(t)
	
	if len(possibleTiles) > 0:
		var choosen = possibleTiles.pick_random()

		ownedTiles.erase(choosen)
		opponentOwnedTiles.append(choosen)

		set_cells_terrain_connect([choosen], 2, get_cell_tile_data(choosen).terrain)


# Recursively check if tile is connected to castle
func is_connected_to_castle(connected: Array, tile: Vector2i, owned: Array) -> Array:
	var neighbors = get_surrounding_cells(tile).filter(func(x): return x in owned)
	for n in neighbors:
		if n not in connected:
			connected.append(n)
			connected = is_connected_to_castle(connected, n, owned)
	return connected

# Remove tiles that are no longer connected to the main castle
func remove_disconnected_tiles(start: Vector2i, owned: Array) -> void:

	var connected : Array = is_connected_to_castle([start], start, owned)
	var lost : Array = []

	for tile in owned:
		if tile not in connected:
			lost.append(tile)
	
	for tile in lost:
		owned.erase(tile)
		set_cells_terrain_connect([tile], 0, get_cell_tile_data(tile).terrain)
