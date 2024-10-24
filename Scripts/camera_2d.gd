extends Camera2D

@export var speed = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#if Input.is_action_pressed(("ui_down")) and position.y < limit_bottom:
		#position.y += 1000
	#if Input.is_action_pressed(("ui_up")) and position.y > limit_top:
		#position.y -= 1000
	
	if Input.is_action_pressed(("ui_right")) and position.x < limit_right:
		position.x += 1 * speed
	if Input.is_action_pressed(("ui_left")) and position.x > limit_left:
		position.x -= 1 * speed
	if Input.is_action_pressed(("ui_down")) and position.y < limit_bottom:
		position.y += 1 * speed
	if Input.is_action_pressed(("ui_up")) and position.y > limit_top:
		position.y -= 1 * speed
