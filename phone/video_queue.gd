extends Node

var prev_videos: Array[Video]
var next_videos: Array[Video]
var current_video: Video

func next_video() -> Video:
	if current_video:
		prev_videos.append(current_video)
	
	if next_videos.is_empty():
		_randomize_video()
	else:
		current_video = next_videos.pop_front()
	
	return current_video

func prev_video() -> Video:
	if prev_videos.is_empty():
		return null
	
	next_videos.insert(0, current_video)
	current_video = prev_videos.pop_back()
	return current_video

func _randomize_video() -> void:
	current_video = Video.create(VideoTable.randomize())
