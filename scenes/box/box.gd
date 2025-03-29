@tool
extends RigidBody2D
class_name Box

enum Type {
	COMMON,  ## 正常
	BIGOTRY, ## 偏见。重力系数0.05，重量5倍。
}

@export var box_type:Type = Type.COMMON:set = _set_box_type

@onready var image: Sprite2D = $Image

const TILE_COMMON = preload("res://assets/kenney_pixel-platformer/Tiles/tile_0009.png")
const TILE_BIGOTRY = preload("res://assets/kenney_pixel-platformer/Tiles/tile_0011.png")
#const TILE_0010 = preload("res://assets/kenney_pixel-platformer/Tiles/tile_0010.png")

func _ready() -> void:
	box_type = box_type

func _set_box_type(value:Type):
	box_type = value
	## TODO:需要一点视觉区别
	
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
