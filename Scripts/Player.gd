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
		) -> void:
		
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
	func update_resources() -> void:
		self.lumber += self.lumberPerTurn
		self.stone += self.stonePerTurn
		self.grain += self.grainPerTurn
		self.gold += self.goldPerTurn
		
	func reset_player() -> void:
		self.lumber = 0
		self.lumberPerTurn = 0
		self.stone = 0
		self.stonePerTurn = 0
		self.grain = 0
		self.grainPerTurn = 0
		self.gold = 0
		self.goldPerTurn = 0
		
	# Returns the data of the player as a dictionary
	func get_data_dict() -> Dictionary:
		return {
			"lumber": self.lumber,
			"lumberPerTurn": self.lumberPerTurn,
			"stone": self.stone,
			"stonePerTurn": self.stonePerTurn,
			"grain": self.grain,
			"grainPerTurn": self.grainPerTurn,
			"gold": self.gold,
			"goldPerTurn": self.goldPerTurn
		}
	
	# Imports the data of the player from a dictionary
	func set_data_dict(dict: Dictionary) -> void:
		self.lumber = dict.lumber
		self.lumberPerTurn = dict.lumberPerTurn
		self.stone = dict.stone
		self.stonePerTurn = dict.stonePerTurn
		self.grain = dict.grain
		self.grainPerTurn = dict.grainPerTurn
		self.gold = dict.gold
		self.goldPerTurn = dict.goldPerTurn
