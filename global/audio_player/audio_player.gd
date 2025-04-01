extends Node

func play(audio: AudioStream,single = false,fade_in_time:float = 1.0 ):
	if not audio:
		print("no audio!")
		return
	
	if single:
		stop()  # 如果要求单独播放，先停止所有音频
	
	# 遍历所有子节点中的音频播放器
	for player: AudioStreamPlayer in get_children():
		if not player.playing:
			player.stream = audio
			
			# 淡入效果处理 ------------------------
			var original_volume = player.volume_db  # 保存原始音量
			player.volume_db = -80                   # 起始音量设为静音
			# 创建音量渐变效果
			var tween = create_tween()
			tween.tween_property(player, "volume_db", original_volume, fade_in_time)
			# ------------------------ 淡入处理结束
			
			player.play()
			return  # 找到可用播放器后立即退出

func stop():
	# 停止所有子节点的音频播放器
	for player: AudioStreamPlayer in get_children():
		player.stop()
