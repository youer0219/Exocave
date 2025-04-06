extends Control


@export_file var restart_level_path:String

func _ready() -> void:
	CoreSystem.scene_manager.preload_scene(restart_level_path)

func _on_restart_button_pressed() -> void:
	CoreSystem.scene_manager.change_scene_async(restart_level_path)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
