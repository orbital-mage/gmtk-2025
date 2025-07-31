extends ScrollContainer

var video_scene = preload("res://phone/video.tscn")

var current_video: Control
var next_video: Control
var scroll := false

@onready var container: Container = $VBoxContainer

func _ready() -> void:
	current_video = _new_video()

func _process(delta: float) -> void:
	State.snooze(delta)
	
	if scroll:
		scroll_vertical += delta * 1200
		if scroll_vertical == size.y:
			scroll = false
			current_video.queue_free()
			current_video = next_video
			next_video = null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			print('up')
	
	if event.is_action_pressed("scroll") and not scroll:
		next_video = _new_video()
		scroll = true
		State.focus()

func _new_video() -> Control:
	var video = video_scene.instantiate() as Control
	container.add_child(video)
	return video
