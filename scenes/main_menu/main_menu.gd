extends Control


@export_file var first_level_path:String
@export_file var title_music_path:String
@export_file var level_music_path:String

func _ready() -> void:
	CoreSystem.scene_manager.preload_scene(first_level_path)
	CoreSystem.audio_manager.play_music(title_music_path,1.0,false)
	CoreSystem.audio_manager.preload_audio(level_music_path,CoreSystem.AudioManager.AudioType.MUSIC)

func _on_button_pressed() -> void:
	CoreSystem.scene_manager.change_scene_async(first_level_path)
	CoreSystem.audio_manager.play_music(level_music_path)
