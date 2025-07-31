class_name Clip extends CenterContainer

signal selected(content: VideoContent)

@export var video_scale: Vector2:
	get:
		return transform.scale
	set(value):
		if transform:
			transform.scale = value
			
var content: VideoContent

@onready var transform: Node2D = $Center/Transform
@onready var panel: Panel = $Center/Transform/Panel

func set_content(content: VideoContent) -> void:
	if panel.get_child_count() > 0:
		panel.remove_child(self.content)
		
	self.content = content
	
	panel.add_child(content)

func clear_content() -> void:
	if panel.get_child_count() > 0:
		panel.remove_child(content)
		
	content = null

func _on_panel_mouse_entered() -> void:
	if content:
		content.play()

func _on_panel_mouse_exited() -> void:
	if content:
		content.pause()

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		var content = self.content
		content.pause()
		clear_content()
		selected.emit(content)
