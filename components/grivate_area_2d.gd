extends Area2D
class_name GravityArea2D

func _ready() -> void:
	EventBus.gravity_flip.connect(
		func(new_gravity_direction:Vector2):
			gravity_direction = new_gravity_direction
	)
