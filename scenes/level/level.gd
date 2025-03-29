extends Node2D


func _ready() -> void:
	EventBus.level_win.connect(
		func():
			SceneManager.change_scene_to_next_level()
	)


func _on_button_pressed() -> void:
	SceneManager.reload_current_level()
