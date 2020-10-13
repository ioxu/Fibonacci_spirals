extends Node2D

var centre = Vector2(ProjectSettings.get_setting("display/window/size/width")/2, ProjectSettings.get_setting("display/window/size/height")/2 )

var npoints = 1000
var nmaxpoints = 5000
var nminpoints = 1
var sprite_pool = []
var spiral_size = 300

var tween_nsamples_startend = [500, 4500]

onready var fps_label = get_node("fps_label")
onready var n_samples_label = get_node("n_samples_label")
onready var n_samples_slider = get_node("n_samples_slider")
onready var dotsprite = get_node("dotsprite")
onready var sprite_pool_parent = get_node("sprite_pool_parent")
onready var tween_nsamples = get_node("tween_nsamples")

export var tween_duration = 2.5

var RESET_POSITION = Vector2(-500, -500)


func _ready():
	# sprite pool .. is it worth it?
	dotsprite.set_scale(Vector2(0.05,0.05))
	dotsprite.set_modulate(Color(0.976563, 0.664752, 0.259399, 0.831373))
	print("creating sprite pool")
	for i in range(nmaxpoints):
		var dupe = dotsprite.duplicate()
		sprite_pool_parent.add_child(dupe)
		sprite_pool.append( dupe )
	print(".. done")
	
	n_samples_label.set_text( "n points %s"%[npoints] )
	update_spiral(npoints)

	_start_tween()


func _process(delta):
	fps_label.set_text( str(Engine.get_frames_per_second()) )


func _start_tween():
	tween_nsamples.interpolate_property(n_samples_slider,  "value",
		tween_nsamples_startend[0], tween_nsamples_startend[1], tween_duration,
		Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween_nsamples.start()


func _on_play_button_toggled(button_pressed):
	if button_pressed:
		tween_nsamples.stop(n_samples_slider,  "value")
	else:
		tween_nsamples.resume(n_samples_slider,  "value")


func _on_tween_nsamples_tween_completed(object, key):
	tween_nsamples_startend.invert()
	_start_tween()


func _on_n_samples_slider_value_changed(value):
	n_samples_label.set_text( "n points %s"%[value] )
	update_spiral(value)


func update_spiral(npoints, nminpoints = 1.0):
	if npoints <= nminpoints or npoints >= nmaxpoints:
		return
		
	var points = fibonacci_spiral_disc( npoints )
	for i in range(npoints):
		var this_sprite = sprite_pool[i]
		this_sprite.set_position(centre + points[i] * spiral_size )

	# hide the rest of the sprites in the pool
	# todo: opt: don't have to move sprites that weren't moved in the step above ..
	for i in range(nmaxpoints - npoints):
		var this_sprite = sprite_pool[i + npoints]
		this_sprite.set_position(RESET_POSITION)


func fibonacci_spiral_disc( npoints ):
	# return positions in a unit radius disc
	# https://www.youtube.com/watch?v=bqtqltqcQhw
	# https://bduvenhage.me/geometry/2019/07/31/generating-equidistant-vectors.html
	var points = []
	var dist_pow = 0.5
	var gr = (1 + sqrt(5.0)) / 2.0 # GOLDEN RATIO ~1.618033988749895
	for i in range(npoints):
		var dist = pow((i + 1) / npoints , dist_pow)
		var angle = 2 * PI * gr  * i
		var x = dist * cos(angle)
		var y = dist * sin(angle)
		points.append(Vector2(x,y))
	return points


func _on_switch_to_3d_button_pressed():
	get_tree().change_scene("res://main-3d.tscn")
