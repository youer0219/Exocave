# 输入系统

输入系统为您的游戏提供了一个灵活而强大的方式来处理用户输入，支持多种输入方式和复杂的输入组合。

## 特性

- 🎮 **多输入方式**：支持键盘、鼠标和游戏手柄
- 🔄 **输入映射**：动态动作和轴映射
- 📊 **输入状态**：跟踪按下、刚按下和刚释放状态
- 🎯 **输入上下文**：上下文敏感的输入处理
- 🔒 **输入锁定**：临时禁用特定输入
- 📱 **项目设置**：通过 Godot 的项目设置进行配置

## 核心组件

### InputManager（输入管理器）

所有输入操作的中央管理器：

- 输入动作映射
- 输入状态跟踪
- 上下文管理

```gdscript
# 通过项目设置配置
core_system/input_system/default_context = "gameplay"
core_system/input_system/input_buffer_time = 0.1
core_system/input_system/double_tap_time = 0.3

# 使用示例
func _ready() -> void:
    var input = CoreSystem.input_manager

    # 注册输入动作
    input.register_action("attack", {
        "keyboard": KEY_SPACE,
        "gamepad": JOY_BUTTON_X
    })

    # 检查输入状态
    if input.is_action_just_pressed("attack"):
        perform_attack()
```

## 使用示例

### 基本输入处理

```gdscript
# 检查输入
func _process(delta: float) -> void:
    var input = CoreSystem.input_manager

    if input.is_action_pressed("move_right"):
        move_right()

    if input.is_action_just_pressed("jump"):
        jump()

    if input.is_action_just_released("crouch"):
        stand_up()
```

### 输入映射

```gdscript
# 注册新的输入动作
func setup_controls() -> void:
    var input = CoreSystem.input_manager

    input.register_action("special_attack", {
        "keyboard": KEY_Q,
        "gamepad": JOY_BUTTON_Y,
        "mouse": MOUSE_BUTTON_RIGHT
    })

    # 重新映射现有动作
    input.remap_action("jump", "keyboard", KEY_SPACE)
```

### 输入上下文

```gdscript
# 设置输入上下文
func setup_input_contexts() -> void:
    var input = CoreSystem.input_manager

    # 菜单上下文
    input.add_context("menu", {
        "ui_up": true,
        "ui_down": true,
        "ui_accept": true,
        "ui_cancel": true
    })

    # 游戏上下文
    input.add_context("gameplay", {
        "move": true,
        "jump": true,
        "attack": true
    })

    # 切换上下文
    input.switch_context("menu")
```

## 最佳实践

1. **输入组织**

   - 使用清晰的动作名称
   - 在上下文中分组相关动作
   - 考虑多种输入方式

2. **性能**

   - 使用输入缓冲处理复杂组合
   - 清理未使用的输入映射
   - 优化 \_process 中的输入检查

3. **用户体验**
   - 支持输入重映射
   - 提供视觉反馈
   - 处理输入冲突

## API 参考

### 输入管理器 InputManager

- `register_action(name: String, mappings: Dictionary) -> void`: 注册新的输入动作
- `remap_action(action: String, device: String, key: int) -> void`: 重新映射现有动作
- `remove_action(name: String) -> void`: 移除输入动作
- `is_action_pressed(action: String) -> bool`: 检查动作是否被按住
- `is_action_just_pressed(action: String) -> bool`: 检查动作是否刚被按下
- `is_action_just_released(action: String) -> bool`: 检查动作是否刚被释放
- `add_context(name: String, actions: Dictionary) -> void`: 添加输入上下文
- `remove_context(name: String) -> void`: 移除输入上下文
- `switch_context(name: String) -> void`: 切换活动上下文
- `lock_action(action: String) -> void`: 锁定特定动作
- `unlock_action(action: String) -> void`: 解锁特定动作
- `get_action_strength(action: String) -> float`: 获取模拟输入强度
