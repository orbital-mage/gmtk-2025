extends ScrollContainer

enum Scroll { NONE, DOWN, UP }

var video_scene = preload("res://phone/video.tscn")

var current_video: Video
var next_video: Video
var scroll := Scroll.NONE

@onready var container: Control = $Videos/Control/CenterContainer

func _ready() -> void:
	Editor.video_submitted.connect(_on_new_video)

func _on_new_video(clips: Array[VideoContent]) -> void:
	container.remove_child(current_video)
	current_video = Video.from_clips(clips)
	container.add_child(current_video)

func _process(delta: float) -> void:
	if scroll == Scroll.DOWN:
		scroll_vertical += delta * 1600
		if scroll_vertical == size.y:
			_choose_video()
	if scroll == Scroll.UP:
		if scroll_vertical == 0 and next_video:
			scroll_vertical = size.y
			
		scroll_vertical -= delta * 1600
		
		if scroll_vertical == 0:
			_choose_video()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			get_viewport().set_input_as_handled()
			#if scroll == Scroll.NONE:
				#next_video = _prev_video()
				#if not next_video:
					#return
				#
				#scroll = Scroll.UP
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			get_viewport().set_input_as_handled()
			#if scroll == Scroll.NONE:
				#next_video = _next_video()
				#scroll = Scroll.DOWN
				#State.focus()

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

func _choose_video() -> void:
	scroll = Scroll.NONE
	container.remove_child(current_video)
	current_video = next_video
	next_video = null
	current_video.play()
