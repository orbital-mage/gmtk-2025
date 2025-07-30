extends Node2D

var video_scene = preload("res://video.tscn")

var current_video: PathFollow2D
var next_video: PathFollow2D
var videos: Array[PathFollow2D]

var scroll := false

func _ready() -> void:
	current_video = _create_video()
	current_video.progress_ratio = 0.5
	
	next_video = _create_video()
	next_video.progress_ratio = 0

func _process(delta: float) -> void:
	if current_video.progress_ratio == 1:
		videos.remove_at(0)
		current_video.queue_free()
		current_video = next_video
		next_video = _create_video()
		scroll = false
	
	State.snooze(delta)
	
	if scroll:
		for video in videos:
			if video.progress_ratio < 1:
				video.progress_ratio += delta

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		scroll = true
		State.focus()

func _create_video() -> PathFollow2D:
	var video = video_scene.instantiate() as PathFollow2D
	
	add_child(video)
	videos.append(video)
	return video
