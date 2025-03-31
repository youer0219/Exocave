extends Node



@export var levels_dic:Dictionary[String,PackedScene]

func change_scene_to_level(level_name:String):
	if not levels_dic.has(level_name):
		print("level_name not exit!")
		return
	
	var new_level = levels_dic[level_name]
	
	if new_level != null:
		get_tree().call_deferred("change_scene_to_packed",new_level)
	else:
		push_error("需要切换到的场景为空！")
