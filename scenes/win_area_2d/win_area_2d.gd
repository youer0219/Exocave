extends Area2D

signal level_win

@export_file var win_sound_path:String

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		CoreSystem.audio_manager.play_sound(win_sound_path)
		level_win.emit()
