extends Area2D


@export var level:Level

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		MySceneManager.change_scene_to_level(level.level_name)
