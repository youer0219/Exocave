extends Node2D


func _ready() -> void:
	EventBus.level_win.connect(
		func():
			print("next level or win!")
	)


func _on_button_pressed() -> void:
	print("restart scene")
