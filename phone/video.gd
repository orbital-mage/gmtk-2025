@tool
class_name Video extends Control

@export var title: String
@export var description: String
@export var tags: Array[String]
@export var video: Resource
@export var duration: float

@onready var info_label: RichTextLabel = $Info
@onready var content: Node2D = $Content
@onready var timer: Timer = $Timer

func _ready() -> void:
	info_label.append_text("[b]%s[/b]" % title)
	info_label.newline()
	info_label.append_text(description)
	info_label.newline()
	
	for tag in tags:
		info_label.append_text("#%s " % tag)
	
	content.add_child(video.instantiate())
	
	timer.wait_time = duration
	timer.start()

func _on_likes_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		print("like")

func _on_share_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		print("share")

func _on_video_completed() -> void:
	print("video finished")
