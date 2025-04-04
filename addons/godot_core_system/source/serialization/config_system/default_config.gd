extends RefCounted

## 默认配置模板

## 获取默认配置
static func get_default_config() -> Dictionary:
	return {
		"game": {
			"language": "en",
			"difficulty": "normal",
			"first_run": true,
		},
		"graphics": {
			"fullscreen": false,
			"vsync": true,
			"resolution": Vector2i(1920, 1080),
			"quality": "high",
		},
		"audio": {
			"master_volume": 1.0,
			"music_volume": 0.8,
			"sfx_volume": 0.8,
			"voice_volume": 0.8,
			"mute": false,
		},
		"input": {
			"mouse_sensitivity": 1.0,
			"gamepad_enabled": true,
			"vibration_enabled": true,
		},
		"gameplay": {
			"tutorial_enabled": true,
			"auto_save": true,
			"auto_save_interval": 300,
			"show_damage_numbers": true,
			"show_floating_text": true,
		},
		"accessibility": {
			"subtitles": true,
			"colorblind_mode": "none",
			"screen_shake": true,
			"text_size": "medium",
		},
		"debug": {
			"logging_enabled": true,
			"log_level": "info",
			"show_fps": false,
			"show_debug_info": false,
		}
	}
