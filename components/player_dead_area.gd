extends Area2D


@export var level:Level

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		CoreSystem.scene_manager.change_scene_async(level.level_path)
