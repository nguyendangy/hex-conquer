extends TileMapLayer

var allTiles : Array
var ownedTiles : Array
var startingTile : Vector2

var rng = RandomNumberGenerator.new()

# probabilities for different terrains
const gras : float = 0.5
const trees : float = 0.3
const mountains : float = 0.1
const river : float = 0.1
const weights : Array = [gras, trees, mountains, river]

# Get weighted random number 
func _get_terrain_type() -> int:
	var remaining_distance = rng.randf()
	for i in weights.size():
		remaining_distance -= weights[i]
		if remaining_distance < 0:
			return i
	return 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set seed for random number generator
	rng.set_seed(1)
	# get all tiles on the map
	allTiles = get_used_cells()
	# set terrain for each tile randomly according weighted distribution
	for tile in allTiles:
		if tile.x == 12 and tile.y == 21:
			# set starting castle
			ownedTiles.append(tile)
			set_cells_terrain_connect([tile], 0, 4)
		else:
			set_cells_terrain_connect([tile], 0, _get_terrain_type())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var global_clicked = event.position
			var pos_clicked = local_to_map(to_local(global_clicked))
			var current_atlas_coords = get_cell_atlas_coords(pos_clicked)
			var current_tile_alt = get_cell_alternative_tile(pos_clicked)
			var main_atlas_id = get_cell_source_id(pos_clicked)
			
			print(pos_clicked)
			
			if pos_clicked in ownedTiles:
				#set_cell(pos_clicked, main_atlas_id, current_atlas_coords, (current_tile_alt + 1) %  2)
				for cell in get_surrounding_cells(pos_clicked):
					if get_cell_tile_data(cell).terrain in [-1,0,1,4]:
						set_cell(cell, get_cell_source_id(cell), \
							get_cell_atlas_coords(cell), (get_cell_alternative_tile(cell) + 1) %  2)

	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			#var global_clicked = event.position
			#print(global_clicked)
			#var pos_clicked = local_to_map(to_local(global_clicked))
			#print(pos_clicked)
			#var current_atlas_coords = get_cell_atlas_coords(pos_clicked)
			#var current_tile_alt = get_cell_alternative_tile(pos_clicked)
			#if current_tile_alt > -1:
				#var number_of_alts_for_clicked = tile_set.get_source(main_atlas_id)\
						#.get_alternative_tiles_count(current_atlas_coords)
				#set_cell(pos_clicked, main_atlas_id, current_atlas_coords, 
						#(current_tile_alt + 1) %  number_of_alts_for_clicked)
