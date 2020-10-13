extends Button

onready var play_icon = load("res://play-button-circle.png")
onready var pause_icon = load("res://pause-button-circle.png")

func _ready():
	pass

func _on_play_button_toggled(button_pressed):
	if button_pressed:
		set_button_icon(pause_icon)
	else:
		set_button_icon(play_icon)
