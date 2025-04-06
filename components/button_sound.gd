extends Node
class_name ButtonSound

@export var button:Button

var click_sound_path = "res://assets/audio/sounds/click1.ogg"
var mouse_enter_sound_path = "res://assets/audio/sounds/switch5.ogg"

func _ready() -> void:
	CoreSystem.audio_manager.preload_audio(click_sound_path,CoreSystem.AudioManager.AudioType.SOUND_EFFECT)
	CoreSystem.audio_manager.preload_audio(mouse_enter_sound_path,CoreSystem.AudioManager.AudioType.SOUND_EFFECT)
	button.pressed.connect(
		func():
			CoreSystem.audio_manager.play_sound(click_sound_path)
	)
	button.mouse_entered.connect(
		func():
			CoreSystem.audio_manager.play_sound(mouse_enter_sound_path)
	)
