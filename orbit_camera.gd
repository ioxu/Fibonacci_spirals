extends Spatial

onready var camera_azimuth = self
onready var camera_zenith = $camera_zenith
onready var camera = $camera_zenith/Camera

var orbiting : bool = false

var mouse_orbit_speed : float = 0.005
var mouse_zoom_speed : float = 0.05
var mmouse_pdt : Vector2 = Vector2()

var last_position : Vector2 = Vector2()

func _ready():
	pass 

func _input(event):
	# middle mouse orbit camera
	if event is InputEventMouseButton and event.button_index == BUTTON_MIDDLE:
		if event.is_pressed():
			orbiting = true
			last_position = event.position
		else:
			orbiting = false

	# mouse scroll dolly
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			camera.translate(Vector3(0,0, - mouse_zoom_speed ))
		elif event.button_index == BUTTON_WHEEL_DOWN:
			camera.translate(Vector3(0,0,  mouse_zoom_speed ))

	# camera orbit
	if event is InputEventMouseMotion and orbiting:
		mmouse_pdt = event.position - last_position
		camera_azimuth.rotate_y( - mmouse_pdt.x * mouse_orbit_speed )
		camera_zenith.rotate_x( - mmouse_pdt.y * mouse_orbit_speed )
		last_position = event.position

