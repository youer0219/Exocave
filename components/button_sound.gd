extends Node
class_name ButtonSound

@export var button:Button

@export var click_sound:AudioStream
@export var mouse_enter_sound:AudioStream

func _ready() -> void:
	button.pressed.connect(
		func():
			SfxPlayer.play(click_sound,false,0.0)
	)
	button.mouse_entered.connect(
		func():
			SfxPlayer.play(mouse_enter_sound,false,0.0)
	)
