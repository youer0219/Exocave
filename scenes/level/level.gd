extends Node2D

@export var level_name:String
@export var next_level_name:String


func _ready() -> void:
	EventBus.level_win.connect(
		func():
			SceneManager.change_scene_to_level(next_level_name)
	)

func _on_button_pressed() -> void:
	SceneManager.change_scene_to_level(level_name)
