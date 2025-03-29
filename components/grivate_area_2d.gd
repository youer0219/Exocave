extends Area2D
class_name GravityArea2D

#enum GravityState {
	#DOWN = Vector2i.DOWN.y,
	#UP = Vector2i.UP.y,
#}
#
#@export var gravity_state:GravityState = GravityState.DOWN:set = _set_gravity_state
#
#func _set_gravity_state(value:GravityState):
	#gravity_state = value
	#gravity_direction.y = gravity_state

func _ready() -> void:
	EventBus.gravity_flip.connect(
		func(new_gravity_direction:Vector2):
			gravity_direction = new_gravity_direction
	)
