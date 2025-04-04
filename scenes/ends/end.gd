extends Control


@export var restart_level_name:String

func _on_restart_button_pressed() -> void:
	MySceneManager.change_scene_to_level(restart_level_name)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
