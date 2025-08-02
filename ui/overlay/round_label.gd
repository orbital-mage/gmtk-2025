extends Label

func _ready() -> void:
	Arena.clones_changed.connect(_on_clones_changed)

func _on_clones_changed(total: int, living: int) -> void:
	text = "%s / %s" % [living, total]
