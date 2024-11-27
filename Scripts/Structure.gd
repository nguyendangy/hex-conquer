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
		if lumber > 0:
			cost += str(lumber) + " lumber\n"
		if stone > 0:
			cost += str(stone) + " stone\n"
		if grain > 0:
			cost += str(grain) + " grain\n"
		if gold > 0:
			cost += str(gold) + " gold\n"
		return cost
