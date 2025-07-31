class_name Video extends Control

static var video_scene = preload("res://phone/video.tscn")

static func create(data: VideoData) -> Video:
	var video = video_scene.instantiate() as Video
	
	for clip in data.clips:
		video.clips.append(clip.instantiate())
	
	video.title = data.title
	video.description = data.description
	
	return video

static func from_clips(clips: Array[VideoContent]) -> Video:
	var video = video_scene.instantiate() as Video
	
	video.clips = clips
	
	video.title = "Lorem Ipsum"
	video.description = "Dolor sit lauren epsum solo shit dogus dippus deltoid dump crampus krangus forrest gump"
	
	return video

@export var title: String
@export var description: String
@export var tags: Array[String]
@export var clips: Array[VideoContent] = []

var current_clip := 0

@onready var info_label: RichTextLabel = $Info
@onready var content: Node2D = $Content

func _ready() -> void:
	info_label.append_text("[b]%s[/b]" % title)
	info_label.newline()
	info_label.append_text(description)
	info_label.newline()
	
	for tag in tags:
		info_label.append_text("#%s " % tag)
	
	for clip in clips:
		content.add_child(clip)
		clip.clip_finished.connect(_on_clip_finished)
		clip.hide()
	
	play()

func play() -> void:
	clips[0].show()
	clips[0].play()

func _on_likes_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		print("like")

func _on_share_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		print("share")

func _on_clip_finished() -> void:
	clips[current_clip].pause()
	clips[current_clip].hide()
	
	current_clip += 1
	if current_clip == clips.size():
		current_clip = 0
	
	clips[current_clip].show()
	clips[current_clip].play()

func _on_video_completed() -> void:
	play()
	print("video finished")
	
