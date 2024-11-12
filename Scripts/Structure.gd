extends Node

var castle = Structure.new(0, -1, [0,1,2,3], [0,1,0], [0,1,0], [0,1,0], [0,1,0])
var camp = Structure.new(1, -1, [0,1], [5,0,0], [0,0,0], [0,0,0], [0,0,0])

# --- Building Types ---
# castle			= 0
# camp			= 1

class Structure:
	
	var type : int
	
	# needs to be placed near a specific tile
	var adjacentTile : int = -1
	
	# can be placed on these types of tiles
	var placedOnTiles : Array
	
	# resources: cost, production, maintenance
	var lumber : Array = [0,0,0]
	var stone : Array = [0,0,0]
	var grain : Array = [0,0,0]
	var gold : Array = [0,0,0]

	
	func _init (type, adjacentTile, placedOnTiles, lumber, stone, grain, gold):
		self.type = type
		self.adjacentTile = adjacentTile
		self.placedOnTiles = placedOnTiles
		self.lumber = lumber
		self.stone = stone
		self.grain = grain
		self.gold = gold
