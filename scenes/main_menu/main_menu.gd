extends Control


@export var first_level_name:String

@export var title_music:AudioStream
@export var level_music:AudioStream

func _ready() -> void:
	MusicPlayer.play(title_music,true,1.0)

func _on_button_pressed() -> void:
	MySceneManager.change_scene_to_level(first_level_name)
	MusicPlayer.play(level_music,true,1.0)
