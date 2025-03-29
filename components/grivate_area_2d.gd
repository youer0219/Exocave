extends Area2D
class_name GravityArea2D

enum GravityState {
	DOWN = Vector2i.DOWN.y,
	UP = Vector2i.UP.y,     
	NULL = Vector2i.ZERO.y, ## 无重力模式。效果不佳，暂时保留，不考虑使用。
}

@export var gravity_state:GravityState = GravityState.DOWN:set = _set_gravity_state

var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _set_gravity_state(value:GravityState):
	gravity_state = value
	gravity_direction.y = gravity_state
	
	if gravity_state == GravityState.NULL:
		gravity = 0.0
	else:
		gravity = default_gravity
