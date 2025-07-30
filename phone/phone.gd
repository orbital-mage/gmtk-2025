extends ScrollContainer

var video_scene = preload("res://phone/video.tscn")

var current_video: Control
var scroll := false

@onready var container: Container = $VBoxContainer

func _ready() -> void:
	_new_video()
	_new_video()

func _process(delta: float) -> void:
	if scroll:
		scroll_vertical += delta * 800
		if scroll_vertical == size.y:
			print('end')
			scroll = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll"):
		scroll = true

func _new_video() -> void:
	var video = video_scene.instantiate()
	container.add_child(video)
