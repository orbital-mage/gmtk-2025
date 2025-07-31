@tool
class_name Video extends Control

@export var title: String
@export var description: String
@export var tags: Array[String]
@export var video_scene: PackedScene
@export var text_content: String
@export var duration: float

var video: VideoContent

@onready var contet_label: Label = $Text
@onready var info_label: RichTextLabel = $Info
@onready var content: Node2D = $Content
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	info_label.append_text("[b]%s[/b]" % title)
	info_label.newline()
	info_label.append_text(description)
	info_label.newline()
	
	for tag in tags:
		info_label.append_text("#%s " % tag)
	
	contet_label.text = text_content
	
	video = video_scene.instantiate()
	content.add_child(video)
	
	timer.wait_time = duration

func play() -> void:
	timer.start()
	audio.play()
	video.play()

func _on_likes_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		print("like")

func _on_share_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		print("share")

func _on_video_completed() -> void:
	audio.play()
	print("video finished")
	
