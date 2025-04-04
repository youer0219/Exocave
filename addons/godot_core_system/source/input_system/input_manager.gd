extends Node

signal action_triggered(action_name: String, event: InputEvent)
signal axis_changed(axis_name: String, value: Vector2)

var _virtual_actions: Dictionary = {}
var _axis_mappings: Dictionary = {}
var _action_states: Dictionary = {}

func _ready():
	# 初始化所有已注册的输入动作状态
	for action in InputMap.get_actions():
		_action_states[action] = false

## 输入事件处理
## [param event] 输入事件
func _input(event: InputEvent):
	# 处理所有已注册的输入动作
	for action in InputMap.get_actions():
		if event.is_action(action):
			var just_pressed = event.is_action_pressed(action)
			var just_released = event.is_action_released(action)
			
			if just_pressed or just_released:
				_action_states[action] = just_pressed
				action_triggered.emit(action, event)

	# 处理虚拟轴输入
	_process_axis_input()

## 注册虚拟轴
## [param axis_name] 轴名称
## [param positive_x] 正向 X 轴动作
## [param negative_x] 负向 X 轴动作
## [param positive_y] 正向 Y 轴动作
## [param negative_y] 负向 Y 轴动作
func register_axis(axis_name: String, positive_x: String = "", negative_x: String = "", 
				  positive_y: String = "", negative_y: String = "") -> void:
	_axis_mappings[axis_name] = {
		"positive_x": positive_x,
		"negative_x": negative_x,
		"positive_y": positive_y,
		"negative_y": negative_y
	}

## 注册虚拟动作
## [param action_name] 动作名称
## [param key_combination] 按键组合
func register_virtual_action(action_name: String, key_combination: Array) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	
	for event in key_combination:
		InputMap.action_add_event(action_name, event)
	_virtual_actions[action_name] = key_combination
	_action_states[action_name] = false

## 检查动作是否被按下
## [param action_name] 动作名称
## [return] 是否按下
func is_action_pressed(action_name: String) -> bool:
	return _action_states.get(action_name, false)

## 检查动作是否刚刚被按下
## [param action_name] 动作名称
## [return] 是否刚刚按下
func is_action_just_pressed(action_name: String) -> bool:
	return Input.is_action_just_pressed(action_name)

## 检查动作是否刚刚被释放
## [param action_name] 动作名称
## [return] 是否刚刚释放
func is_action_just_released(action_name: String) -> bool:
	return Input.is_action_just_released(action_name)

## 获取轴的值
## [param axis_name] 轴名称
## [return] 值 value
func get_axis_value(axis_name: String) -> Vector2:
	if not _axis_mappings.has(axis_name):
		return Vector2.ZERO
	
	var mapping = _axis_mappings[axis_name]
	var result = Vector2.ZERO
	
	if mapping.has("positive_x") and Input.is_action_pressed(mapping.positive_x):
		result.x += 1
	if mapping.has("negative_x") and Input.is_action_pressed(mapping.negative_x):
		result.x -= 1
	if mapping.has("positive_y") and Input.is_action_pressed(mapping.positive_y):
		result.y += 1
	if mapping.has("negative_y") and Input.is_action_pressed(mapping.negative_y):
		result.y -= 1
	
	return result

## 清除所有虚拟输入
func clear_virtual_inputs() -> void:
	for action in _virtual_actions.keys():
		InputMap.erase_action(action)
	_virtual_actions.clear()
	_axis_mappings.clear()
	_action_states.clear()

## 处理虚拟轴输入
func _process_axis_input():
	for axis_name in _axis_mappings:
		var mapping = _axis_mappings[axis_name]
		var axis_value = Vector2.ZERO
		
		if mapping.has("positive_x") and Input.is_action_pressed(mapping.positive_x):
			axis_value.x += 1
		if mapping.has("negative_x") and Input.is_action_pressed(mapping.negative_x):
			axis_value.x -= 1
		if mapping.has("positive_y") and Input.is_action_pressed(mapping.positive_y):
			axis_value.y += 1
		if mapping.has("negative_y") and Input.is_action_pressed(mapping.negative_y):
			axis_value.y -= 1
		
		axis_changed.emit(axis_name, axis_value)
