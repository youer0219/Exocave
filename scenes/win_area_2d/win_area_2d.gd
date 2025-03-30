extends Area2D

@export var win_sound:AudioStream

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		EventBus.level_win.emit()
		SfxPlayer.play(win_sound,false,0.0)
