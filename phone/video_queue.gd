extends Node

var rng = RandomNumberGenerator.new()

var video_scene = preload("res://phone/video.tscn")
var content: Array[PackedScene] = [
	preload("res://scenes/videos/demon_jumpscare.tscn"),
	preload("res://scenes/videos/guy_talking.tscn")
]

var prev_videos: Array[Video]
var next_videos: Array[Video]
var current_video: Video

func next_video() -> Video:
	if current_video:
		prev_videos.append(current_video)
	
	if next_videos.is_empty():
		# TODO: Randomize video here
		current_video = video_scene.instantiate()
		
		current_video.title = str(prev_videos.size() + 1)
		current_video.video_scene = content[rng.randi_range(0, content.size() - 1)]
	else:
		current_video = next_videos.pop_front()
	
	return current_video

func prev_video() -> Video:
	if prev_videos.is_empty():
		return null
	
	next_videos.insert(0, current_video)
	current_video = prev_videos.pop_back()
	return current_video
