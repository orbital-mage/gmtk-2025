extends Node

signal video_submitted(clips: Array[VideoContent])

func submit_video(clips: Array[VideoContent]) -> void:
	video_submitted.emit(clips)
