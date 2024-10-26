extends Camera2D

var minimum_zoom = Vector2(0.7,0.7)
var zoom_speed = 0.05
var panning = false

func _input(event):
	if event.is_action_released('camera_zoom_in'):
		zoom_camera(zoom_speed)
	if event.is_action_released('camera_zoom_out'):
		zoom_camera(-zoom_speed)
	if event.is_action_pressed("camera_pan"):
		panning = true
	elif event.is_action_released("camera_pan"):
		panning = false
	if event is InputEventMouseMotion and panning == true:
		offset -= event.relative / zoom

func zoom_camera(zoom_factor):
	var next_zoom = zoom + zoom * zoom_factor
	if next_zoom > minimum_zoom:
		zoom = next_zoom
	else:
		zoom = minimum_zoom
		offset = Vector2(0,0)
