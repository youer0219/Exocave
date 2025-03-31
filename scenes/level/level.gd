extends Node2D

@export var level_name:String
@export var next_level_name:String

@onready var win_area_2d: Area2D = %WinArea2D
@onready var billboard: Billboard = %Billboard
@onready var label: Label = %Label

func _ready() -> void:
	win_area_2d.level_win.connect(
		func():
			SceneManager.change_scene_to_level(next_level_name)
	)
	billboard.text_update.connect(
		func(text:String):
			label.text = text
	)

func _on_button_pressed() -> void:
	SceneManager.change_scene_to_level(level_name)
