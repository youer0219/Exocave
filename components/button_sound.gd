extends Node
class_name ButtonSound

@export var button:Button

@export var click_sound:AudioStream = preload("uid://dd3xw31mxi0ph")
@export var mouse_enter_sound:AudioStream = preload("uid://0b7l50r1y8vu")

func _ready() -> void:
	button.pressed.connect(
		func():
			SfxPlayer.play(click_sound,false,0.0)
	)
	button.mouse_entered.connect(
		func():
			SfxPlayer.play(mouse_enter_sound,false,0.0)
	)
