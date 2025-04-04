extends Node2D

const InputManager = CoreSystem.InputManager

@onready var input_manager : InputManager = CoreSystem.input_manager
@onready var player_sprite = $PlayerSprite
@onready var status_label = $StatusLabel

# 虚拟动作和轴的名称
const ACTIONS = {
	"attack": "player_attack",
	"jump": "player_jump",
	"movement": "player_movement"
}

func _ready():
	# 设置状态标签
	status_label.text = "按WASD移动，空格跳跃，J攻击"
	
	# 注册虚拟动作
	var jump_event = InputEventKey.new()
	jump_event.keycode = KEY_SPACE
	input_manager.register_virtual_action(ACTIONS.jump, [jump_event])
	
	var attack_event = InputEventKey.new()
	attack_event.keycode = KEY_J
	input_manager.register_virtual_action(ACTIONS.attack, [attack_event])
	
	# 注册移动轴（WASD控制）
	input_manager.register_axis(
		ACTIONS.movement,
		"ui_right",  # 正X轴 - D
		"ui_left",   # 负X轴 - A
		"ui_down",   # 正Y轴 - S
		"ui_up"      # 负Y轴 - W
	)
	
	# 连接信号
	input_manager.action_triggered.connect(_on_action_triggered)
	input_manager.axis_changed.connect(_on_axis_changed)

func _process(_delta):
	# 更新玩家精灵的位置
	var movement = input_manager.get_axis_value(ACTIONS.movement)
	if movement != Vector2.ZERO:
		player_sprite.position += movement * 5

## 动作触发回调
func _on_action_triggered(action_name: String, _event: InputEvent):
	match action_name:
		ACTIONS.jump:
			if input_manager.is_action_just_pressed(action_name):
				_show_action_status("跳跃！")
				var tween = create_tween()
				tween.tween_property(player_sprite, "position:y", 
					player_sprite.position.y - 50, 0.3)
				tween.tween_property(player_sprite, "position:y", 
					player_sprite.position.y, 0.3)
		
		ACTIONS.attack:
			if input_manager.is_action_just_pressed(action_name):
				_show_action_status("攻击！")
				var tween = create_tween()
				tween.tween_property(player_sprite, "rotation", 
					player_sprite.rotation + PI, 0.3)
				tween.tween_property(player_sprite, "rotation", 
					player_sprite.rotation, 0.3)

## 轴变化回调
func _on_axis_changed(axis_name: String, value: Vector2):
	if axis_name == ACTIONS.movement and value != Vector2.ZERO:
		_show_action_status("移动：" + str(value))

## 显示动作状态
func _show_action_status(text: String):
	status_label.text = text
	await get_tree().create_timer(1.0).timeout
	status_label.text = "按WASD移动，空格跳跃，J攻击"
