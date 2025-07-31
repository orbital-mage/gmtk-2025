extends Node

var rng = RandomNumberGenerator.new()

var video_scene = preload("res://phone/video.tscn")

var table = {
	"talking": {
		"videos": [ preload("res://scenes/videos/guy_talking.tscn") ],
		"text": {
			"top 5 heavenly blessings": preload("res://assets/sounds/blessings.mp3"),
			"watch till the end for a free giveaway!": preload("res://assets/sounds/giveaway.mp3"),
			"like this video or you'll get got!": preload("res://assets/sounds/get_got.mp3"),
			"you should never brush your teeth!": preload("res://assets/sounds/teeth.mp3")
		},
		"titles": [
			"My Confession",
			"A must watch!",
			"please watch to the end"
		],
		"descriptions": [
			"I didn't want you to hear about it like this...",
			"hope you enjoy this one!",
			"I might be a bit rambly in this one, please bear with me",
			"this is important stuff! you better pay attention!"
		]
	},
	"jumpscare": {
		"videos": [ preload("res://scenes/videos/demon_jumpscare.tscn") ],
		"text": {
			"IM GOING TO KILL YOU!": preload("res://assets/sounds/kill_you.mp3"),
			"BOO!": preload("res://assets/sounds/boo.mp3"),
			"GET STICKBUGGED!": preload("res://assets/sounds/stickbug.mp3")
		},
		"titles": [
			"HAHAHAHA",
			"Fart Productions",
			"The Demon",
			"My Secret"
		],
		"descriptions": [
			"I can't believe you fell for that...",
			"Smelly video for you",
			"this has been a long time coming... i hope you enjoy!",
			"HAHAHAHAHAHAHAHHAHAHAHAHHHAHAHHAHHAH"
		]
	}
}

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
	
	current_video.title = str(prev_videos.size() + 1)
	
	var video_type = _random_item(table.keys())
	
	current_video.video_scene = _random_item(table[video_type].videos)
	
	var text = _random_item(table[video_type].text.keys())
	current_video.text_content = text
	current_video.audio = table[video_type].text[text]
	
	current_video.title = _random_item(table[video_type].titles)
	current_video.description = _random_item(table[video_type].descriptions)

func _random_item(arr: Array) -> Variant:
	return arr[rng.randi_range(0, arr.size() - 1)]
