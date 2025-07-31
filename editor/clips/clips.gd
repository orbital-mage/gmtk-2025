extends HBoxContainer

signal clip_selected(content: VideoContent)

var rng = RandomNumberGenerator.new()
var content = [
	preload("res://videos/old/cat.tscn"),
	preload("res://videos/old/explode.tscn"),
	preload("res://videos/old/found_out.tscn"),
	preload("res://videos/old/walking.tscn")
]

func _ready() -> void:
	_randomize_clips()

func _on_clip_selected(content: VideoContent) -> void:
	clip_selected.emit(content)

func _on_submit() -> void:
	_randomize_clips()

func _randomize_clips() -> void:
	for clip: Clip in find_children("*", "Clip"):
		clip.set_content(_random_item(content).instantiate())
		clip.selected.connect(_on_clip_selected)

func _random_item(arr: Array) -> Variant:
	return arr[rng.randi_range(0, arr.size() - 1)]
