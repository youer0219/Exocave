extends RigidBody2D
class_name Box

enum Type {
	COMMON,  ## 正常
	BIGOTRY, ## 偏见。重力系数0.05，重量5倍。
}

@export var box_type:Type = Type.COMMON:set = _set_box_type


func _set_box_type(value:Type):
	box_type = value
	## TODO:需要一点视觉区别
	match box_type:
		Type.COMMON:
			mass = 1.0
			gravity_scale = 1.0
		Type.BIGOTRY:
			mass = 5.0
			gravity_scale = 0.05
