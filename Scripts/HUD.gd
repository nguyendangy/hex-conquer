extends CanvasLayer


# main node to access functions and values
@onready var main : Node = get_node("/root/Main")

# text displaying the current turn
@onready var turn : Label = get_node("TurnLabel")

# text displaying the resources
@onready var resourceAmount1 : Label = get_node("Resources/Amounts/Label1")
@onready var resourceAmount2 : Label = get_node("Resources/Amounts/Label2")
@onready var resourceAmount3 : Label = get_node("Resources/Amounts/Label3")
@onready var resourceAmount4 : Label = get_node("Resources/Amounts/Label4")

# text displaying the increase of the resources
@onready var resourceIncrease1 : Label = get_node("Resources/Increases/Label1")
@onready var resourceIncrease2 : Label = get_node("Resources/Increases/Label2")
@onready var resourceIncrease3 : Label = get_node("Resources/Increases/Label3")
@onready var resourceIncrease4 : Label = get_node("Resources/Increases/Label4")

# container holding the building buttons
@onready var buildings : Node = get_node("Buildings")


# updates the hud to show the current values
func update_hud():
	
	# set the amount of the resources
	resourceAmount1.text = str(main.lumber)
	resourceAmount2.text = str(main.stone)
	resourceAmount3.text = str(main.grain)
	resourceAmount4.text = str(main.gold)
	
	# set the increase of the resources
	resourceIncrease1.text = "(+" + str(main.lumberPerTurn) + ")"
	resourceIncrease2.text = "(+" + str(main.stonePerTurn) + ")"
	resourceIncrease3.text = "(+" + str(main.grainPerTurn) + ")"
	resourceIncrease4.text = "(+" + str(main.goldPerTurn) + ")"
	
	# set number of turn
	turn.text = "Turn " + str(main.currentTurn)
	
	# hide buildings
	set_buttons_visibility(false)

# called when the "End Turn" button is pressed
func _on_EndTurnButton_pressed ():
	
	main.end_turn()

# Set visibility of buttons
func set_buttons_visibility(visible: bool) -> void:
	
	# TODO: Check if building can be placed here
	buildings.visible = visible
