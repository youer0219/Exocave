extends Node2D

const SceneManager = CoreSystem.SceneManager

@onready var scene_manager : SceneManager = CoreSystem.scene_manager
@onready var status_label = $UI/StatusLabel
@onready var buttons = $UI/Buttons

# 场景路径
const SCENE_PATHS = {
	"scene1": "res://addons/godot_core_system/examples/scene_demo/scenes/scene1.tscn",
	"scene2": "res://addons/godot_core_system/examples/scene_demo/scenes/scene2.tscn",
	"scene3": "res://addons/godot_core_system/examples/scene_demo/scenes/scene3.tscn"
}

func _ready():
	# 预加载所有场景
	for path in SCENE_PATHS.values():
		scene_manager.preload_scene(path)
	
	# 连接信号
	scene_manager.scene_loading_started.connect(_on_scene_loading_started)
	scene_manager.scene_loading_progress.connect(_on_scene_loading_progress)
	scene_manager.scene_changed.connect(_on_scene_changed)
	scene_manager.scene_loading_finished.connect(_on_scene_loading_finished)
	
	# 设置状态标签
	status_label.text = "选择一个转场效果和目标场景"

## 切换到场景1（无转场效果）
func _on_scene1_pressed():
	scene_manager.change_scene_async(SCENE_PATHS.scene1)

## 切换到场景2（淡入淡出效果）
func _on_scene2_pressed():
	scene_manager.change_scene_async(
		SCENE_PATHS.scene2, 
		{}, 
		false, 
		SceneManager.TransitionEffect.FADE, 
	)

## 切换到场景3（滑动效果）
func _on_scene3_pressed():
	scene_manager.change_scene_async(
		SCENE_PATHS.scene3,
		{}, 
		false, 
		SceneManager.TransitionEffect.SLIDE,
		1.0
	)

## 场景加载开始回调
func _on_scene_loading_started(scene_path: String):
	status_label.text = "开始加载场景：" + scene_path
	buttons.visible = false

## 场景加载进度回调
func _on_scene_loading_progress(progress: float):
	status_label.text = "加载进度：%.1f%%" % (progress * 100)

## 场景切换回调
func _on_scene_changed(_old_scene: Node, _new_scene: Node):
	status_label.text = "场景切换完成"

## 场景加载完成回调
func _on_scene_loading_finished():
	status_label.text = "加载完成"
	buttons.visible = true
