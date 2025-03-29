extends Area2D
class_name GravityFlipArea2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		EventBus.gravity_flip.emit()
