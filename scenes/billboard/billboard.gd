extends Area2D
class_name Billboard

signal text_update(text:String)

@export_multiline var text:String

@onready var image: Sprite2D = $Image

var is_player_exist:bool = false:
	set(value):
		is_player_exist = value
		update_billboard()
var is_mouse_exist:bool = false:
	set(value):
		is_mouse_exist = value
		update_billboard()

func _ready() -> void:
	hide_outline()

func update_billboard():
	if is_player_exist or is_mouse_exist:
		outline()
		text_update.emit(text)
	else:
		hide_outline()
		text_update.emit("")

func outline():
	image.material.set_shader_parameter("width",0.5)

func hide_outline():
	image.material.set_shader_parameter("width",0.0)

func _on_mouse_entered() -> void:
	is_mouse_exist = true

func _on_mouse_exited() -> void:
	is_mouse_exist = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_exist = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_exist = false
