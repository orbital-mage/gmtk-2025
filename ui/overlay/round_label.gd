extends Label

var tween: Tween

@onready var drink_text: Control = $"../../Drink"

func _ready() -> void:
	Arena.clones_changed.connect(_on_clones_changed)

func _on_clones_changed(total: int, living: int) -> void:
	modulate = Color.PALE_VIOLET_RED
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	text = "%s/%s" % [living, total]
	
	drink_text.visible = total % 5 == 0
