@tool
extends Area2D
class_name GravityFlipArea2D

signal gravity_flip

enum GravityState {
	DOWN,
	UP,
	LEFT,
	RIGHT,
}

@onready var image: Sprite2D = $Image

@export var gravity_state:GravityState = GravityState.UP:set = _set_gravity_state
@export_file var gravity_change_sound_path:String

const UP_IMAGE_REGION_X := 170
const DOWN_IMAGE_REGION_X := 187
const LEFT_IMAGE_REGION_X := 203
const RIGHT_IMAGE_REGION_X := 221

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		gravity_flip.emit(get_gravity_state_direction())
		CoreSystem.audio_manager.play_sound(gravity_change_sound_path)

func _set_gravity_state(value:GravityState):
	gravity_state = value
	
	if not is_node_ready():
		await ready
	
	match gravity_state:
		GravityState.DOWN:
			image.texture.region.position.x = DOWN_IMAGE_REGION_X
		GravityState.UP:
			image.texture.region.position.x = UP_IMAGE_REGION_X
		GravityState.LEFT:
			image.texture.region.position.x = RIGHT_IMAGE_REGION_X
		GravityState.RIGHT:
			image.texture.region.position.x = LEFT_IMAGE_REGION_X
		_:
			push_error("错误的gravity_state值！")

func get_gravity_state_direction()->Vector2:
	match gravity_state:
		GravityState.DOWN:
			return Vector2.DOWN
		GravityState.UP:
			return Vector2.UP
		GravityState.LEFT:
			return Vector2.LEFT
		GravityState.RIGHT:
			return Vector2.RIGHT
		_:
			push_error("错误的gravity_state值！")
			return Vector2.DOWN
