@tool
extends RigidBody2D
class_name Box

enum Type {
	COMMON,  ## 正常
	BIGOTRY, ## 偏见。重力系数0.05，重量5倍。
}

@export var box_type:Type = Type.COMMON:set = _set_box_type

@onready var image: Sprite2D = $Image

const TILE_COMMON = preload("uid://nhigfcgcg4o1")
const TILE_BIGOTRY = preload("uid://bybfsyllk3ba3")

func _ready() -> void:
	box_type = box_type

func _set_box_type(value:Type):
	box_type = value
	
	if not is_node_ready():
		await ready
	
	match box_type:
		Type.COMMON:
			mass = 1.0
			gravity_scale = 1.0
			image.texture = TILE_COMMON
		Type.BIGOTRY:
			mass = 5.0
			gravity_scale = 0.1
			image.texture = TILE_BIGOTRY
