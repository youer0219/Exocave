extends Control


@export var first_level_name:String

func _on_button_pressed() -> void:
	SceneManager.change_scene_to_level(first_level_name)
