extends ScrollContainer

enum Scroll { NONE, DOWN, UP }

var video_scene = preload("res://phone/video.tscn")

var current_video: Video
var next_video: Video
var scroll := Scroll.NONE

@onready var container: Container = $VBoxContainer

func _ready() -> void:
	current_video = _next_video()

func _process(delta: float) -> void:
	State.snooze(delta)
	
	if scroll == Scroll.DOWN:
		scroll_vertical += delta * 1600
		if scroll_vertical == size.y:
			scroll = Scroll.NONE
			container.remove_child(current_video)
			current_video = next_video
			next_video = null
	if scroll == Scroll.UP:
		if scroll_vertical == 0 and next_video:
			scroll_vertical = size.y
			
		scroll_vertical -= delta * 1600
		
		if scroll_vertical == 0:
			scroll = Scroll.NONE
			container.remove_child(current_video)
			current_video = next_video
			next_video = null

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			get_viewport().set_input_as_handled()
			if scroll == Scroll.NONE:
				next_video = _prev_video()
				if not next_video:
					return
				
				scroll = Scroll.UP
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			get_viewport().set_input_as_handled()
			if scroll == Scroll.NONE:
				next_video = _next_video()
				scroll = Scroll.DOWN
				State.focus()

func _next_video() -> Video:
	var video = VideoQueue.next_video()
	container.add_child(video)
	return video

func _prev_video() -> Video:
	var video = VideoQueue.prev_video()
	if not video:
		return null
	
	container.add_child(video)
	container.move_child(video, 0)
	return video
