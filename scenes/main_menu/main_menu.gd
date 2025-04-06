extends Control

@export var title_music:AudioStream
@export var level_music:AudioStream
@export_file var first_level_path:String


func _ready() -> void:
	MusicPlayer.play(title_music,true,1.0)
	CoreSystem.scene_manager.preload_scene(first_level_path)

func _on_button_pressed() -> void:
	CoreSystem.scene_manager.change_scene_async(first_level_path)
	MusicPlayer.play(level_music,true,1.0)
