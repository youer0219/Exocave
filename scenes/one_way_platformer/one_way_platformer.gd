@tool
extends StaticBody2D
class_name OneWayPlatformer

enum Direction {
	UP,  ## 标识可以从下往上跳。实际射线指向下。
	DOWN,## 标识可以从上往下跳。实际射线指向上。
}

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var direction:Direction:set = _set_direction

func _set_direction(value:Direction):
	direction = value
	
	if not is_node_ready():
		await ready
	
	collision_shape_2d.rotation_degrees = 180.0 if direction == Direction.DOWN else 0.0
