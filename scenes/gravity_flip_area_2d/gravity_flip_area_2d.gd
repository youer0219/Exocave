@tool
extends Area2D
class_name GravityFlipArea2D

@onready var image: Sprite2D = $Image

@export var gravity_state:Vector2 = Vector2.UP:set = _set_gravity_state

const UP_IMAGE_REGION_X := 170
const DOWN_IMAGE_REGION_X := 187
const LEFT_IMAGE_REGION_X := 203
const RIGHT_IMAGE_REGION_X := 221

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		EventBus.gravity_flip.emit(gravity_state)

func _set_gravity_state(value:Vector2):
	gravity_state = value
	
	if not is_node_ready():
		await ready
	
	match gravity_state:
		Vector2.DOWN:
			image.texture.region.position.x = DOWN_IMAGE_REGION_X
		Vector2.UP:
			image.texture.region.position.x = UP_IMAGE_REGION_X
		Vector2.LEFT:
			image.texture.region.position.x = LEFT_IMAGE_REGION_X
		Vector2.RIGHT:
			image.texture.region.position.x = RIGHT_IMAGE_REGION_X
		_:
			push_error("错误的gravity_state值！")
