extends TileMapLayer

# Tiles
var allTiles : Array
var ownedTiles : Array
var startingTile : Vector2i = Vector2i(12, 21)
var selectedTile : Vector2i = Vector2i(-1, -1)

# Buttons
@onready var BuildingButton1 = get_node("../HUD/Building1")
@onready var BuildingButton2 = get_node("../HUD/Building2")
@onready var BuildingButton3 = get_node("../HUD/Building3")
@onready var BuildingButton4 = get_node("../HUD/Building4")

var rng = RandomNumberGenerator.new()

# Probabilities for different terrains
const gras : float = 0.5
const trees : float = 0.3
const mountains : float = 0.1
const river : float = 0.1
const weights : Array = [gras, trees, mountains, river]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set seed for random number generator
	rng.set_seed(1)
	# get all tiles on the map
	allTiles = get_used_cells()
	# set terrain for each tile randomly according weighted distribution
	for tile in allTiles:
		if tile == startingTile:
			# set starting castle
			ownedTiles.append(tile)
			set_cells_terrain_connect([tile], 0, 4)
		else:
			set_cells_terrain_connect([tile], 0, _get_terrain_type())


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
			# check if click was on map
			if pos_clicked in allTiles:
				# debug output
				print_debug(pos_clicked)
				
				if pos_clicked != selectedTile:
					# reset previously clicked tile
					set_cell(
						selectedTile, 
						get_cell_source_id(selectedTile),
						get_cell_atlas_coords(selectedTile),
						(get_cell_alternative_tile(selectedTile) + 1) %  2
					)
					# show buttons
					_set_buttons_visibility(true)
					# set selected tile
					selectedTile = pos_clicked
				else:
					# hide buttons
					_set_buttons_visibility(false)
					# reset tile if clicked again
					selectedTile = Vector2i(-1, -1)

				set_cell(
					pos_clicked, 
					get_cell_source_id(pos_clicked),
					get_cell_atlas_coords(pos_clicked),
					(get_cell_alternative_tile(pos_clicked) + 1) %  2
				)
				
				#if pos_clicked in ownedTiles:
					#for cell in get_surrounding_cells(pos_clicked):
						#if get_cell_tile_data(cell).terrain in [-1,0,1,4]:
							#set_cell(cell, get_cell_source_id(cell), \
								#get_cell_atlas_coords(cell), (get_cell_alternative_tile(cell) + 1) %  2)

# Set visibility of buttons
func _set_buttons_visibility(visible: bool) -> void:
	BuildingButton1.visible = visible
	BuildingButton2.visible = visible
	BuildingButton3.visible = visible
	BuildingButton4.visible = visible

# Get weighted random number 
func _get_terrain_type() -> int:
	var remaining_distance = rng.randf()
	for i in weights.size():
		remaining_distance -= weights[i]
		if remaining_distance < 0:
			return i
	return 0
