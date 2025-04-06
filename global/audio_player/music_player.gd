extends "res://global/audio_player/audio_player.gd"

func _on_audio_stream_player_finished() -> void:
	print($AudioStreamPlayer.playing)
	$AudioStreamPlayer.play()
