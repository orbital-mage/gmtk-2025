extends Node

var rng = RandomNumberGenerator.new()

var video_scene = preload("res://phone/video.tscn")
var video_data = [
	preload("res://phone/data/jumpscare_data.tres"),
	preload("res://phone/data/talking_data.tres")
]

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
	current_video = video_scene.instantiate()
	
	var data = _random_item(video_data) as VideoData
	
	current_video.video_scene = _random_item(data.content)
	
	var text = _random_item(data.audio) as VideoText
	current_video.text_content = text.text
	current_video.audio = text.audio
	
	current_video.title = _random_item(data.titles)
	current_video.description = _random_item(data.descriptions)

func _random_item(arr: Array) -> Variant:
	return arr[rng.randi_range(0, arr.size() - 1)]
