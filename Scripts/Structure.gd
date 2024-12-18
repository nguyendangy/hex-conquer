extends Node


class StructureObject:
	
	var terrain_id: int
	
	# needs to be placed near a specific tile
	var adjacentTileType: int = -1
	
	# can be placed on these types of tiles
	var placedOnTiles: Array
	
	# initial cost of building
	var lumber: int
	var stone: int
	var grain: int
	var gold: int
	
	# benefit of building per turn
	var lumberPerTurn: int
	var stonePerTurn: int
	var grainPerTurn: int
	var goldPerTurn: int
	
	# cost of building per turn
	var lumberCostPerTurn: int
	var stoneCostPerTurn: int
	var grainCostPerTurn: int
	var goldCostPerTurn: int

	
	func _init (terrain_id: int, adjacentTileType: int, placedOnTiles: Array, 
		lumber: int = 0, lumberPerTurn: int = 0, lumberCostPerTurn: int = 0,
		stone: int = 0, stonePerTurn: int = 0, stoneCostPerTurn: int = 0,
		grain: int = 0, grainPerTurn: int = 0, grainCostPerTurn: int = 0,
		gold: int = 0, goldPerTurn: int = 0, goldCostPerTurn: int = 0
		):
		
		self.terrain_id = terrain_id
		self.adjacentTileType = adjacentTileType
		self.placedOnTiles = placedOnTiles
		self.lumber = lumber
		self.lumberPerTurn = lumberPerTurn
		self.lumberCostPerTurn = lumberCostPerTurn
		self.stone = stone
		self.stonePerTurn = stonePerTurn
		self.stoneCostPerTurn = stoneCostPerTurn
		self.grain = grain
		self.grainPerTurn = grainPerTurn
		self.grainCostPerTurn = grainCostPerTurn
		self.gold = gold
		self.goldPerTurn = goldPerTurn
		self.goldCostPerTurn = goldCostPerTurn

	# Returns the cost of the structure as string
	func cost_string() -> String:
		var cost: String = ""
		cost += str(lumber) + "\n"
		cost += str(stone) + "\n"
		cost += str(grain) + "\n"
		cost += str(gold)
		return cost

	# Resets the structure's variables
	func reset_structure() -> void:
		self.lumber = self.lumberCostPerTurn
		self.stone = self.stoneCostPerTurn
		self.grain = self.grainCostPerTurn
		self.gold = self.goldCostPerTurn
	
	# Returns the data of the structure as a dictionary
	func get_data_dict() -> Dictionary:
		return {
			"lumber": self.lumber,
			"lumberPerTurn": self.lumberPerTurn,
			"lumberCostPerTurn": self.lumberCostPerTurn,
			"stone": self.stone,
			"stonePerTurn": self.stonePerTurn,
			"stoneCostPerTurn": self.stoneCostPerTurn,
			"grain": self.grain,
			"grainPerTurn": self.grainPerTurn,
			"grainCostPerTurn": self.grainCostPerTurn,
			"gold": self.gold,
			"goldPerTurn": self.goldPerTurn,
			"goldCostPerTurn": self.goldCostPerTurn
		}
	
	# Imports the data of the structure from a dictionary
	func set_data_dict(dict: Dictionary) -> void:
		self.lumber = dict.lumber
		self.lumberPerTurn = dict.lumberPerTurn
		self.lumberCostPerTurn = dict.lumberCostPerTurn
		self.stone = dict.stone
		self.stonePerTurn = dict.stonePerTurn
		self.stoneCostPerTurn = dict.stoneCostPerTurn
		self.grain = dict.grain
		self.grainPerTurn = dict.grainPerTurn
		self.grainCostPerTurn = dict.grainCostPerTurn
		self.gold = dict.gold
		self.goldPerTurn = dict.goldPerTurn
		self.goldCostPerTurn = dict.goldCostPerTurn
