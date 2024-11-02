extends Node2D

# current amount of each resource we have
var lumber : int = 0
var stone : int = 0
var grain : int = 0
var gold : int = 0

# amount of each resource we get each turn
var lumberPerTurn : int = 1
var stonePerTurn : int = 1
var grainPerTurn : int = 1
var goldPerTurn : int = 1

var currentTurn : int = 1

# components
@onready var hud : Node = get_node("HUD")
@onready var map : Node = get_node("Map")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# update the HUD when the game starts
	hud.update_hud()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# called when the player ends the turn
func end_turn ():
	
	# update our current resource amounts
	lumber += lumberPerTurn
	stone += stonePerTurn
	grain += grainPerTurn
	gold += goldPerTurn
	
	# increase current turn
	currentTurn += 1
	
	# update the HUD
	hud.update_hud()
	
	# deselect tile if selected
	map.clear_selected_tile()
	
