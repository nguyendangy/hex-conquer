extends TileMapLayer

const main_atlas_id = 1
const this_was_great = "yup"

# all the tiles in the game
var allTiles : Array
var rng = RandomNumberGenerator.new()




func _ready ():
	
	allTiles = get_used_cells()
	for tile in allTiles:
		var my_random_number = rng.randi_range(0, 1)
		set_cell(tile, main_atlas_id, Vector2i(0,0), my_random_number)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var global_clicked = event.position
			print(global_clicked)
			var pos_clicked = local_to_map(to_local(global_clicked))
			print(pos_clicked)
			var current_atlas_coords = get_cell_atlas_coords(pos_clicked)
			var current_tile_alt = get_cell_alternative_tile(pos_clicked)
			if current_tile_alt > -1:
				var number_of_alts_for_clicked = tile_set.get_source(main_atlas_id)\
						.get_alternative_tiles_count(current_atlas_coords)
				set_cell(pos_clicked, main_atlas_id, current_atlas_coords, 
						(current_tile_alt + 1) %  number_of_alts_for_clicked)
				#for cell in get_surrounding_cells(pos_clicked):
					#set_cell(cell, main_atlas_id, current_atlas_coords, (current_tile_alt + 1) %  number_of_alts_for_clicked)
