extends Camera2D

var minimum_zoom: Vector2 = Vector2(0.7,0.7)
var panning: bool = false


@export var zoom_speed: float = 0.05
@export var pan_speed: float = 1.0
@export var rotation_speed: float = 1.0

@export var can_pan: bool
@export var can_zoom: bool
@export var can_rotate: bool

var touch_points: Dictionary = {}
var start_distance
var start_zoom


func _input(event):
	# zoom on computer
	if event.is_action_released('camera_zoom_in'):
		zoom_camera(zoom_speed)
	if event.is_action_released('camera_zoom_out'):
		zoom_camera(-zoom_speed)
	
	# pan on computer
	if event.is_action_pressed("camera_pan"):
		panning = true
	elif event.is_action_released("camera_pan"):
		panning = false
	if event is InputEventMouseMotion and panning == true:
		offset -= event.relative / zoom
		
	# zoom and pan on touchscreen
	if event is InputEventScreenTouch:
		handle_touch(event)
	elif event is InputEventScreenDrag:
		handle_drag(event)


func zoom_camera(zoom_factor):
	var next_zoom = zoom + zoom * zoom_factor
	if next_zoom > minimum_zoom:
		zoom = next_zoom
	else:
		zoom = minimum_zoom
		offset = Vector2(0,0)


func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)
	
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
		start_zoom = zoom
	elif touch_points.size() == 0:
		can_pan = true
	elif touch_points.size() < 2:
		start_distance = 0


func handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
	
	if touch_points.size() == 1:
		if can_pan:
			offset -= event.relative / zoom
			
	elif touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		var current_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
		var zoom_factor = start_distance / current_dist
		
		can_pan = false
		
		if can_zoom:
			var next_zoom = start_zoom / zoom_factor
			if next_zoom > minimum_zoom:
				zoom = next_zoom
			else:
				zoom = minimum_zoom
				offset = Vector2(0,0)
