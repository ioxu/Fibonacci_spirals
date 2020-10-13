extends Spatial

onready var spiral = $Fibonacci_spiral_3d
onready var tween_n_points = $Tween

var interp_npoints = [0,0]

onready var fps_label = $HBoxContainer/fps_label


func _ready():
	interp_npoints = [30, spiral.get_max_points()]
	_start_tween()


func _process(dt):
	fps_label.set_text( str(Engine.get_frames_per_second()) )


func _start_tween():
	tween_n_points.interpolate_method(spiral,  "update_spiral",
		interp_npoints[0], interp_npoints[1], 3.0,
		Tween.TRANS_EXPO  , Tween.EASE_OUT  )
	tween_n_points.start()


func _on_Tween_tween_completed(_object, _key):
	interp_npoints.invert()
	_start_tween()


func _on_switch_to_2d_button_pressed():
	get_tree().change_scene("res://main.tscn")
