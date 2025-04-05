extends Control


@export var restart_level_name:String
@export_file var restart_level_path:String

func _on_restart_button_pressed() -> void:
	#MySceneManager.change_scene_to_level(restart_level_name)
	CoreSystem.scene_manager.change_scene_async(restart_level_path)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
