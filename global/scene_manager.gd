extends Node

@export var levels:Array[PackedScene]

var curr_level_index := 0

func is_last_level()->bool:
	return curr_level_index == levels.size() - 1

func change_scene_to_next_level():
	if is_last_level():
		print("已经是最后一关了")
		return
	
	curr_level_index += 1
	get_tree().call_deferred("change_scene_to_packed",levels[curr_level_index])

func reload_current_level():
	get_tree().call_deferred("change_scene_to_packed",levels[curr_level_index])
