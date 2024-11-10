extends Node

var castle = Structure.new(0, -1, [0,1,2,3], [1,0], [1,0], [1,0], [1,0])
var camp = Structure.new(1, -1, [0,1], [0,0], [0,0], [0,0], [0,0])

# --- Building Types ---
# castle			= 0
# camp			= 1

class Structure:
	
	var type : int
	
	# needs to be placed near a specific tile
	var adjacentTile : int = -1
	
	# can be placed on these tiles
	var placedOnTiles : Array
	
	# resource the structure produces
	var lumberProduction : int = 0
	var stoneProduction : int = 0
	var grainProduction : int = 0
	var goldProduction : int = 0
	
	# resource the structure needs to be maintained
	var lumberConsumption : int = 0
	var stoneConsumption : int = 0
	var grainConsumption : int = 0
	var goldConsumption : int = 0
	
	func _init (type, adjacentTile, placedOnTiles, lumber, stone, grain, gold):
		self.type = type
		self.adjacentTile = adjacentTile
		self.placedOnTiles = placedOnTiles
		self.lumberProduction = lumber[0]
		self.lumberConsumption = lumber[1]
		self.stoneProduction = stone[0]
		self.stoneConsumption = stone[1]
		self.grainProduction = grain[0]
		self.grainConsumption = grain[1]
		self.goldProduction = gold[0]
		self.goldConsumption = gold[1]
