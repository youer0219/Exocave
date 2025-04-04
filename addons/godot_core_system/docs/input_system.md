# Input System

The Input System provides a flexible and powerful way to handle user input in your game, supporting multiple input methods and complex input combinations.

## Features

- 🎮 **Multiple Input Methods**: Support for keyboard, mouse, and gamepads
- 🔄 **Input Mapping**: Dynamic action and axis mapping
- 📊 **Input States**: Track pressed, just pressed, and just released states
- 🎯 **Input Contexts**: Context-sensitive input handling
- 🔒 **Input Locking**: Temporarily disable specific inputs
- 📱 **Project Settings**: Configure through Godot's project settings

## Core Components

### InputManager

Central manager for all input operations:
- Input action mapping
- Input state tracking
- Context management

```gdscript
# Configure through project settings
core_system/input_system/default_context = "gameplay"
core_system/input_system/input_buffer_time = 0.1
core_system/input_system/double_tap_time = 0.3

# Usage example
func _ready() -> void:
    var input = CoreSystem.input_manager
    
    # Register input action
    input.register_action("attack", {
        "keyboard": KEY_SPACE,
        "gamepad": JOY_BUTTON_X
    })
    
    # Check input state
    if input.is_action_just_pressed("attack"):
        perform_attack()
```

## Usage Examples

### Basic Input Handling

```gdscript
# Check for input
func _process(delta: float) -> void:
    var input = CoreSystem.input_manager
    
    if input.is_action_pressed("move_right"):
        move_right()
    
    if input.is_action_just_pressed("jump"):
        jump()
    
    if input.is_action_just_released("crouch"):
        stand_up()
```

### Input Mapping

```gdscript
# Register new input action
func setup_controls() -> void:
    var input = CoreSystem.input_manager
    
    input.register_action("special_attack", {
        "keyboard": KEY_Q,
        "gamepad": JOY_BUTTON_Y,
        "mouse": MOUSE_BUTTON_RIGHT
    })
    
    # Remap existing action
    input.remap_action("jump", "keyboard", KEY_SPACE)
```

### Input Contexts

```gdscript
# Setup input contexts
func setup_input_contexts() -> void:
    var input = CoreSystem.input_manager
    
    # Menu context
    input.add_context("menu", {
        "ui_up": true,
        "ui_down": true,
        "ui_accept": true,
        "ui_cancel": true
    })
    
    # Gameplay context
    input.add_context("gameplay", {
        "move": true,
        "jump": true,
        "attack": true
    })
    
    # Switch context
    input.switch_context("menu")
```

## Best Practices

1. **Input Organization**
   - Use clear action names
   - Group related actions in contexts
   - Consider multiple input methods

2. **Performance**
   - Use input buffering for complex combinations
   - Clean up unused input mappings
   - Optimize input checks in _process

3. **User Experience**
   - Support input remapping
   - Provide visual feedback
   - Handle input conflicts

## API Reference

### InputManager
- `register_action(name: String, mappings: Dictionary) -> void`: Register new input action
- `remap_action(action: String, device: String, key: int) -> void`: Remap existing action
- `remove_action(name: String) -> void`: Remove input action
- `is_action_pressed(action: String) -> bool`: Check if action is held down
- `is_action_just_pressed(action: String) -> bool`: Check if action was just pressed
- `is_action_just_released(action: String) -> bool`: Check if action was just released
- `add_context(name: String, actions: Dictionary) -> void`: Add input context
- `remove_context(name: String) -> void`: Remove input context
- `switch_context(name: String) -> void`: Switch active context
- `lock_action(action: String) -> void`: Lock specific action
- `unlock_action(action: String) -> void`: Unlock specific action
- `get_action_strength(action: String) -> float`: Get analog input strength
