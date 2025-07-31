extends HBoxContainer

var slots: Array[Clip]
var selected := 0

@onready var submit_button: Button = $Submit

func _ready() -> void:
	for clip: Clip in find_children("*", "Clip"):
		slots.append(clip)

func _on_clip_selected(content: VideoContent) -> void:
	slots[selected].set_content(content)
	
	selected += 1
	
	if selected == slots.size():
		submit_button.disabled = false

func _on_submit() -> void:
	selected = 0
	submit_button.disabled = true
	
	var clips: Array[VideoContent]
	for slot in slots:
		clips.append(slot.content)
		slot.clear_content()
	
	Editor.submit_video(clips)
