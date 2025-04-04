extends Node

## 状态机管理器

# 信号

## 状态机注册
signal state_machine_registered(id: StringName)
## 状态机注销
signal state_machine_unregistered(id: StringName)
## 状态机启动
signal state_machine_started(id: StringName)
## 状态机停止
signal state_machine_stopped(id: StringName)

## 状态机字典
## key: 状态机ID
## value: 状态机
var _state_machines: Dictionary[StringName, BaseStateMachine] = {}

func _process(delta: float) -> void:
	for state_machine in _state_machines.values():
		if state_machine.is_active:
			state_machine.update(delta)

func _physics_process(delta: float) -> void:
	for state_machine in _state_machines.values():
		if state_machine.is_active:
			state_machine.physics_update(delta)

func _input(event: InputEvent) -> void:
	for state_machine in _state_machines.values():
		if state_machine.is_active:
			state_machine.handle_input(event)

## 注册状态机
## [param id] 状态机ID
## [param agent] 状态机所属节点
## [param initial_state] 初始状态, 非空字符串表示自动启动
## [param msg] 传递给状态机的消息
func register_state_machine(
		id: StringName, 
		state_machine: BaseStateMachine,
		agent: Object = null,
		initial_state: StringName = &"", 
		msg: Dictionary = {}) -> void:
	if _state_machines.has(id):
		push_warning("State machine %s already registered" % id)
		return
	
	_state_machines[id] = state_machine
	state_machine.agent = agent
	state_machine.ready()
	if not initial_state.is_empty():
		start_state_machine(id, initial_state, msg)
	state_machine_registered.emit(id)

## 注销状态机
## [param id] 状态机ID
func unregister_state_machine(id: StringName) -> void:
	if not _state_machines.has(id):
		return
	
	var state_machine = _state_machines[id]
	stop_state_machine(id)
	_state_machines.erase(id)
	state_machine.dispose()
	state_machine_unregistered.emit(id)

## 获取状态机
## [param id] 状态机ID
func get_state_machine(id: StringName) -> BaseStateMachine:
	return _state_machines.get(id)

## 启动状态机
## [param id] 状态机ID
## [param initial_state] 初始状态
## [param msg] 传递给状态机的消息
func start_state_machine(
		id: StringName, 
		initial_state: StringName, 
		msg: Dictionary = {}) -> void:
	var state_machine = get_state_machine(id)
	if not state_machine:
		push_error("State machine %s does not exist" % id)
		return
	if initial_state.is_empty():
		push_error("Initial state cannot be empty")
		return
	
	state_machine.start(initial_state, msg)
	state_machine_started.emit(id)

## 停止状态机
## [param id] 状态机ID
func stop_state_machine(id: StringName) -> void:
	var state_machine = get_state_machine(id)
	if not state_machine:
		push_error("State machine %s does not exist" % id)
		return
	
	state_machine.stop()
	state_machine_stopped.emit(id)

## 获取所有状态机
## [return] 所有状态机的数组
func get_all_state_machines() -> Array[BaseStateMachine]:
	return _state_machines.values()

## 获取所有状态机ID
## [return] 所有状态机ID的数组
func get_all_state_machine_ids() -> Array[StringName]:
	return _state_machines.keys()

## 清除所有状态机
func clear_state_machines() -> void:
	for id in _state_machines.keys():
		unregister_state_machine(id)
