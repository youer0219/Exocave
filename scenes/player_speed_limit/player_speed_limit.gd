extends Area2D


var player_once_entered:bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not player_once_entered:
		body.velocity *= 0.05
		player_once_entered = true
