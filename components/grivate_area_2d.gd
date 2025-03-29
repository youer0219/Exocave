extends Area2D
class_name GravityArea2D

enum GravityState {
	DOWN = Vector2i.DOWN.y,
	UP = Vector2i.UP.y,
}

@export var gravity_state:GravityState = GravityState.DOWN:set = _set_gravity_state

var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _set_gravity_state(value:GravityState):
	gravity_state = value
	gravity_direction.y = gravity_state
