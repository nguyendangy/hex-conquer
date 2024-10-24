extends Camera2D

var zoomTarget : Vector2
@export var zoomSpeed : float = 10

var dragStartMousePos : Vector2 = Vector2.ZERO
var dragStartCameraPos : Vector2 = Vector2.ZERO
var isDragging : bool = false

var zoom_speed = 0.1
var panning = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	zoomTarget = zoom


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#Zoom(delta)
	#SimplePan(delta)
	#ClickAndDrag()
	pass
	
#func _input(event):
	#if event.is_action_released('camera_zoom_in'):
		#zoom_camera(-zoom_speed, event.position)
	#if event.is_action_released('camera_zoom_out'):
		#zoom_camera(zoom_speed, event.position)
	#if event.is_action_pressed("camera_pan"):
		#panning = true
	#elif event.is_action_released("camera_pan"):
		#panning = false
	#if event is InputEventMouseMotion and panning == true:
		#offset -= event.relative * zoom
	
func zoom_camera(zoom_factor, mouse_position):
	var viewport_size = get_viewport().size
	var previous_zoom = zoom
	zoom += zoom * zoom_factor
	offset += ((viewport_size * 0.5) - mouse_position) * (zoom - previous_zoom)


func Zoom(delta):
	
	#var mouse = get_viewport().get_mouse_position()
	
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoomTarget *= 1.1
		#zoom_at_point(1.1, mouse)
	if Input.is_action_just_pressed("camera_zoom_out"):
		zoomTarget *= 0.9
		#zoom_at_point(0.9, mouse)
		
	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)
	
func SimplePan(delta):
	var moveAmount = Vector2.ZERO
	if Input.is_action_pressed("camera_move_right"):
		moveAmount.x += 1
	if Input.is_action_pressed("camera_move_left"):
		moveAmount.x -= 1
	if Input.is_action_pressed("camera_move_down"):
		moveAmount.y += 1
	if Input.is_action_pressed("camera_move_up"):
		moveAmount.y -= 1
		
	position += moveAmount * delta * 1000 * (1/zoom.x)
	
func ClickAndDrag():
	if !isDragging and Input.is_action_just_pressed("camera_pan"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
	
	if isDragging and Input.is_action_just_released("camera_pan"):
		isDragging = false
		
	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - moveVector * 1/zoom.x
