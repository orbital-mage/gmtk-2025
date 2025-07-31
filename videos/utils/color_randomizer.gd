extends CanvasItem

func _ready() -> void:
	modulate = Color.from_hsv(randf(), 1, 1)
