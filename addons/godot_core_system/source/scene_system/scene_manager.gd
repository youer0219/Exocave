extends Node

## 场景管理器

# 信号
## 开始加载场景
signal scene_loading_started(scene_path: String)
## 场景切换
signal scene_changed(old_scene: Node, new_scene: Node)
## 结束加载场景
signal scene_loading_finished()

## 场景转换效果
enum TransitionEffect {
	NONE,       ## 无转场效果
	FADE,       ## 淡入淡出
	SLIDE,      ## 滑动
	DISSOLVE    ## 溶解
}

# 属性
## 当前场景
var _current_scene: Node = null
## 转场层
var _transition_layer: CanvasLayer
## 转场矩形
var _transition_rect: ColorRect
## 场景栈
var _scene_stack: Array[Dictionary] = []

## 资源管理器
var _resource_manager : CoreSystem.ResourceManager:
	get:
		return CoreSystem.resource_manager
## 日志管理器
var _logger : CoreSystem.Logger:
	get:
		return CoreSystem.logger

var _preloaded_scenes: Array[String] = []


func _ready() -> void:
	var root : Window = get_tree().root
	if not root:
		return
	_setup_transition_layer(root)

## 预加载场景
## @param scene_path 场景路径
func preload_scene(scene_path: String) -> void:
	_preloaded_scenes.append(scene_path)
	_resource_manager.load_resource(scene_path, _resource_manager.LOAD_MODE.LAZY)

## 异步切换场景
## [param scene_path] 场景路径
## [param scene_data] 场景数据
## [param push_to_stack] 是否保存当前场景到栈
## [param effect] 转场效果
## [param duration] 转场持续时间
## [param callback] 切换完成回调
func change_scene_async(
		scene_path: String, 
		scene_data: Dictionary = {},
		push_to_stack: bool = false,
		effect: TransitionEffect = TransitionEffect.NONE, 
		duration: float = 0.5, 
		callback: Callable = Callable()) -> void:
	scene_loading_started.emit(scene_path)
	
	# 开始转场效果
	if effect != TransitionEffect.NONE:
		await _start_transition(effect, duration)
	
	# 加载新场景
	var new_scene : Node = _resource_manager.get_instance(scene_path)
	if not new_scene:
		var scene_resource : PackedScene = _resource_manager.get_cached_resource(scene_path)
		new_scene = scene_resource.instantiate()
	
	if not new_scene:
		_logger.error("Failed to load scene: %s" % scene_path)
		return
	
	if new_scene.has_method("init_state"):
		new_scene.init_state(scene_data)
	
	await _do_scene_switch(new_scene, effect, duration, callback, push_to_stack)

## 返回上一个场景
## [param effect] 转场效果
## [param duration] 持续时间
## [param callback] 回调
func pop_scene_async(effect: TransitionEffect = TransitionEffect.NONE, 
					duration: float = 0.5, 
					callback: Callable = Callable()) -> void:
	if _scene_stack.is_empty():
		return
		
	var prev_scene_data = _scene_stack.pop_back()
	var prev_scene = prev_scene_data.scene
	
	# 开始转场效果
	if effect != TransitionEffect.NONE:
		await _start_transition(effect, duration)
	
	if prev_scene.has_method("restore_state"):
		prev_scene.restore_state(prev_scene_data.data)
	prev_scene.show()
	
	await _do_scene_switch(prev_scene, effect, duration, callback)

## 子场景管理
## [param parent_node] 父节点
## [param scene_path] 场景路径
## [param scene_data] 场景数据
## [return] 子场景
func add_sub_scene(
		parent_node: Node, 
		scene_path: String, 
		scene_data: Dictionary = {}) -> Node:
	var scene_resource = _resource_manager.load_resource(scene_path)
	var sub_scene = scene_resource.instantiate()
	if sub_scene.has_method("init_state"):
		sub_scene.init_state(scene_data)
	parent_node.add_child(sub_scene)
	return sub_scene

## 获取当前场景
func get_current_scene() -> Node:
	return _current_scene

## 清除预加载的场景
func clear_preloaded_scenes() -> void:
	for scene_path in _preloaded_scenes:
		_resource_manager.clear_resource_cache(scene_path)
	_preloaded_scenes.clear()

## 开始转场效果
## @param effect 转场效果
## @param duration 转场持续时间
func _start_transition(effect: TransitionEffect, duration: float) -> void:
	_transition_rect.visible = true
	
	match effect:
		TransitionEffect.FADE:
			# 淡入淡出
			var tween = create_tween()
			tween.tween_property(_transition_rect, "color:a", 1.0, duration)
			await tween.finished
		
		TransitionEffect.SLIDE:
			# 滑动
			_transition_rect.color.a = 1.0
			_transition_rect.position.x = -_transition_rect.size.x
			var tween = create_tween()
			tween.tween_property(_transition_rect, "position:x", 0, duration)
			await tween.finished
		
		TransitionEffect.DISSOLVE:
			# 溶解
			#TODO 这里可以添加更复杂的溶解效果
			var tween = create_tween()
			tween.tween_property(_transition_rect, "color:a", 1.0, duration)
			await tween.finished

## 结束转场效果
## @param effect 转场效果
## @param duration 转场持续时间
func _end_transition(effect: TransitionEffect, duration: float) -> void:
	match effect:
		TransitionEffect.FADE:
			## 淡出
			var tween = create_tween()
			tween.tween_property(_transition_rect, "color:a", 0.0, duration)
			await tween.finished
		
		TransitionEffect.SLIDE:
			## 滑动
			var tween = create_tween()
			tween.tween_property(_transition_rect, "position:x", _transition_rect.size.x, duration)
			await tween.finished
		
		TransitionEffect.DISSOLVE:
			## 溶解
			var tween = create_tween()
			tween.tween_property(_transition_rect, "color:a", 0.0, duration)
			await tween.finished
	
	_transition_rect.visible = false

## 设置转场层
func _setup_transition_layer(root: Window):
	_transition_layer = CanvasLayer.new()
	_transition_layer.layer = 128
	add_child(_transition_layer)
	
	_transition_rect = ColorRect.new()
	_transition_rect.color = Color(0, 0, 0, 0)
	_transition_rect.visible = false
	_transition_layer.add_child(_transition_rect)
	
	root.connect("size_changed", _on_viewport_size_changed)
	_on_viewport_size_changed()

## 设置转场矩形大小
func _on_viewport_size_changed():
	if _transition_rect:
		_transition_rect.size = get_viewport().get_visible_rect().size

## 私有方法：执行场景切换
## [param new_scene] 新场景
## [param effect] 转场效果
## [param duration] 持续时间
## [param callback] 回调
## [param save_current] 是否保存当前场景
func _do_scene_switch(
		new_scene: Node, 
		effect: TransitionEffect, 
		duration: float, callback: Callable, 
		save_current: bool = false) -> void:
	var old_scene : Node = _current_scene

	if save_current and _current_scene:
		# 保存当前场景到栈
		_scene_stack.push_back({
			"scene": _current_scene, 
			"data": _current_scene.save_state() if _current_scene.has_method("save_state") else {},
		})
		# 不销毁当前场景，只是隐藏他
		_current_scene.hide()
		_current_scene.get_parent().remove_child(_current_scene)
	else:
		# 如果不需要保存状态，则直接销毁当前场景
		if _current_scene:
			_current_scene.get_parent().remove_child(_current_scene)
			_current_scene.queue_free()

	# 添加新场景
	get_tree().root.call_deferred("add_child", new_scene)
	#CoreSystem.get_tree().current_scene = new_scene
	_current_scene = new_scene
		
	scene_changed.emit(old_scene, new_scene)
	
	# 结束转场效果
	if effect != TransitionEffect.NONE:
		await _end_transition(effect, duration)

	# 回调
	if callback.is_valid():
		callback.call()        
	scene_loading_finished.emit()
