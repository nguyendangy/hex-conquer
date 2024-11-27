extends Node


class PlayerObject:
	
	# ID of the owned terrain
	var terrain_id: int
	
	# Position of main castle
	var startingTile: Vector2i
	
	# Amount of resources the player has
	var lumber: int
	var stone: int
	var grain: int
	var gold: int
	
	# Amount of resources the player gets
	var lumberPerTurn: int
	var stonePerTurn: int
	var grainPerTurn: int
	var goldPerTurn: int


	func _init (terrain_id: int, startingTile: Vector2i,
			lumber: int = 0, lumberPerTurn: int = 0,
			stone: int = 0, stonePerTurn: int = 0,
			grain: int = 0, grainPerTurn: int = 0,
			gold: int = 0, goldPerTurn: int = 0
		):
		
		self.terrain_id = terrain_id
		self.startingTile = startingTile
		self.lumber = lumber
		self.lumberPerTurn = lumberPerTurn
		self.stone = stone
		self.stonePerTurn = stonePerTurn
		self.grain = grain
		self.grainPerTurn = grainPerTurn
		self.gold = gold
		self.goldPerTurn = goldPerTurn
	
	# Increase the resources of the player
	func update_resources():
		self.lumber += self.lumberPerTurn
		self.stone += self.stonePerTurn
		self.grain += self.grainPerTurn
		self.gold += self.goldPerTurn
		
	func reset_player():
		self.lumber = lumber
		self.lumberPerTurn = 0
		self.stone = 0
		self.stonePerTurn = 0
		self.grain = 0
		self.grainPerTurn = 0
		self.gold = 0
		self.goldPerTurn = 0
