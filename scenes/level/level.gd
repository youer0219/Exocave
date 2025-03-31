extends Node2D

@export var level_name:String
@export var next_level_name:String

@onready var win_area_2d: Area2D = %WinArea2D
@onready var billboard: Billboard = %Billboard
@onready var label: Label = %Label
@onready var gravity_flip_area_2ds: Node2D = %GravityFlipArea2Ds
@onready var gravity_area_2d: Area2D = %GravityArea2D

func _ready() -> void:
	win_area_2d.level_win.connect(
		func():
			SceneManager.change_scene_to_level(next_level_name)
	)
	billboard.text_update.connect(
		func(text:String):
			label.text = text
	)
	
	var gravity_flip_area_2d_array:Array[Area2D] = Array(gravity_flip_area_2ds.get_children(),TYPE_OBJECT,"Area2D",Area2D)
	for gravity_flip_area_2d:Area2D in gravity_flip_area_2d_array:
		gravity_flip_area_2d.gravity_flip.connect(
			func(new_gravity_direction:Vector2):
				gravity_area_2d.gravity_direction = new_gravity_direction
		)

func _on_button_pressed() -> void:
	SceneManager.change_scene_to_level(level_name)
